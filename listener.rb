require 'sinatra/base'
require 'yaml'

class Listener < Sinatra::Base
  @@config = YAML.load_file("./config.yml")

  error 403 do
    'Access forbidden!'
  end

  before do
    403 if ENV['RACK_ENV'] == "production" and not @@config['github_ip_list'].include?(request.ip)
  end

  get '/' do
    raise "application root directory not found" unless File.directory?(@@config['application_root'])
    %x{ set -x; cd #{ @@config['application_root'] } && git pull }
  end
end

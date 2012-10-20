require 'sinatra/base'
require 'yaml'

class Listener < Sinatra::Base
  @@config = YAML.load_file("./config/config.yml")

  error 403 do
    'Access forbidden!'
  end

  get '/pull' do
    403 if ENV['RACK_ENV'] == "production" and not @@config['github_ip_list'].include?(request.ip)

    command = [ "cd #{@@config['application_root']}" ]
    command.push @@config['before_cmd'] if @@config['before_cmd']
    command.push "git push"
    command.push @@config['after_cmd'] if @@config['after_cmd']

    raise "application root directory not found" unless File.directory?(@@config['application_root'])
    %x{ set -x; #{ command.join(" && ")} }
  end
end

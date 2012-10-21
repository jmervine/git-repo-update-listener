require 'sinatra/base'
require 'yaml'
require 'pp'

class Listener < Sinatra::Base
  @@config = YAML.load_file("./config/config.yml")

  error do
    'ACK!'
  end

  post '/pull' do

    raise "forbidden" unless @@config['github_ip_list'].include?(request.ip)

    command = [ "cd #{@@config['application_root']}" ]
    command.push @@config['before_cmd'] if @@config['before_cmd']
    command.push "git pull"
    command.push @@config['after_cmd'] if @@config['after_cmd']

    raise "application root directory not found" unless File.directory?(@@config['application_root'])
    %x{ set -x; #{ command.join(" && ")} }
  end
end

require 'sinatra/base'
require 'yaml'
require 'pp'

class Listener < Sinatra::Base
  @@config = YAML.load_file("./config/config.yml")

  configure :development, :production do
    enable :logging
  end

  error do
    'ACK!'
  end

  get '/pull' do
    "Git Hook Listener, see: https://github.com/jmervine/git-repo-update-listener"
  end

  post '/pull' do
    logger.info "Request IP: #{request.env['HTTP_X_REAL_IP']}"

    match_found = false
    @@config['github_ip_list'].each do |ippattern|
      if !!(request.env['HTTP_X_REAL_IP'].match(Regexp.new(ippattern)))
        match_found = true
      else
        logger.error "#{request.env['HTTP_X_REAL_IP']} failed to match '#{ippattern}'"
      end
    end

    raise "forbidden" unless match_found

    command = [ "cd #{@@config['application_root']}" ]
    command.push @@config['before_cmd'] if @@config['before_cmd']
    command.push "git pull #{@@config['github_remote']||"origin"} #{@@config['github_branch']||"master"}"
    command.push @@config['after_cmd'] if @@config['after_cmd']

    raise "application root directory not found" unless File.directory?(@@config['application_root'])
    %x{ set -x; #{ command.join(" && ")} }
  end
end

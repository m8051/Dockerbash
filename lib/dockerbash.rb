require "dockerbash/version"
require "highline/import"
require "rest-client"
require "fileutils"
require "colorize"
require "open3"
require "json"
require "mkmf"

module MakeMakefile::Logging
  @logfile = File::NULL
  @quiet = true
end

module Dockerbash

  class Client

    def initialize(url, port)
      @docker_url = url
      @docker_port = port
      banner
      @docker_path = find_docker()
    end

    def select_docker_container(ids, tmp_work)
      counter = 0
      docker_ids = []
      ids = get_docker_containers_ids()
      ids.each do |i|
        container = RestClient.get "#{@docker_url}:#{@docker_port}/containers/#{i}/json"
        Dir.mkdir(tmp_work) unless File.exists?(tmp_work)
        container2json = open("#{tmp_work}#{i}.json", 'w')
        container2json.truncate(0)
        container2json.write(container)
        container2json.close
        
        json = File.read("#{tmp_work}#{i}.json")
        content_json = JSON.parse(json)
        container_name = content_json['Name'].green
        container_name.delete!("/")
        container_ip = content_json['NetworkSettings']['IPAddress'].blue
        container_started = content_json['State']['StartedAt'].gsub("T",' - ').blue
        container_id = content_json['Id']
        
        puts "#{counter}. Container: #{container_name}\t IP: #{container_ip}\t Started At: #{container_started}"
        docker_ids << container_id
        counter += 1
      end

      selected_id = ask("Container?  ", Integer) { |q| q.in = 0..docker_ids.count }
      command = "/usr/bin/docker exec -t -i #{docker_ids[selected_id]} /bin/bash"
      exec(command)
    end
    
    private
    
    def banner
     puts '         _            _             _               _       '.green.bold
     puts '      __| | ___   ___| | _____ _ __| |__   __ _ ___| |___   '.green.bold
     puts '     / _` |/ _ \ / __| |/ / _ \  __|  _ \ / _` / __|  _  \  '.white.bold
     puts '    | (_| | (_) | (__|   <  __/ |  | |_) | (_| \__ \ | | |  '.white.bold
     puts '     \__,_|\___/ \___|_|\_\___|_|  |_.__/ \__,_|___/_| |_|  '.yellow.bold
     puts '                                                            '.yellow.bold
     puts '                                                 by m8051.  '.red.bold
     puts '                                                            '
   end

   def find_docker()
     docker_path = find_executable('docker', path = nil)
     if docker_path.nil? || docker_path.empty?
       msg = " -- Docker not found, is the docker package installed?".red
       abort(msg)
     else
       return docker_path
     end
   end

   def get_docker_containers_ids()
     docker_containers_ids = []
     stdout, stdeerr, status = Open3.capture3("#{@docker_path} ps -aq -f status=running")
     if stdout.nil? || stdout.empty?
       msg = "  -- Is the Docker daemon running and the containers up?".red
       abort(msg)
     else
       concat_stdout = stdout.gsub(/\n/,' ')
       docker_containers_ids = concat_stdout.split(" ")
       return docker_containers_ids
     end
   end

  end

end

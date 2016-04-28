require "dockerbash/version"
require "highline/import"
require "fileutils"
require "colorize"
require "open3"
require "mkmf"

# Preventing mkmf to:
#  => litter with log files.
#  => non-verbose stdout
module Logging
   @logfile = File::NULL
   @quiet = true
end

module Dockerbash

  class Client

    def initialize()
      banner
      @docker_path = find_docker()
    end

    def select_docker_container()
      counter = 0
      docker_ids = []
      ids = get_docker_containers_ids()
      ids.each do |i|
        cn_stdout, cn_stderr, cn_status = Open3.capture3("#{@docker_path} inspect --format={{.Name}} #{i}")
        container_name = cn_stdout.gsub(/\n/,' ')
        container_name.delete!("/")

        ci_stdout, ci_stderr, ci_status = Open3.capture3("#{@docker_path} inspect --format={{.NetworkSettings.IPAddress}} #{i}")
        container_ip = ci_stdout.gsub(/\n/,' ')
        container_ip.delete("/")

        cb_stdout, cb_stderr, cb_status = Open3.capture3("#{@docker_path} inspect --format='{{range $p, $conf := .NetworkSettings.Ports}} {{$p}} -> {{(index $conf 0).HostPort}} {{end}}' #{i}")
        container_bindings = cb_stdout.gsub(/\n/,' ')

        container_ids = i
        puts "#{counter}. Container:#{container_name}\tIp:#{container_ip}\tPorts:#{container_bindings}"
        docker_ids << container_ids
        counter += 1
      end

      selected_id = ask("Container? ", Integer) { |q| q.in = 0..docker_ids.count }
      command = "#{@docker_path} exec -t -i #{docker_ids[selected_id]} /bin/bash"
      exec(command)
    end
    
    private
    
    def banner
     puts '       _            _             _               _       '.green.bold
     puts '    __| | ___   ___| | _____ _ __| |__   __ _ ___| |___   '.green.bold
     puts '   / _` |/ _ \ / __| |/ / _ \  __|  _ \ / _` / __|  _  |  '.white.bold
     puts '  | (_| | (_) | (__|   <  __/ |  | |_) | (_| \__ \ | | |  '.white.bold
     puts '   \____|\___/ \___|_|\_\___|_|  |____/ \____|___/_| |_|  '.yellow.bold
     puts '                                                          '.yellow.bold
     puts '                                     v.0.1.0  - by m8051  '.red.bold
     puts ''
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

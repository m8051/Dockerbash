# Dockerbash

A script to make it easier to execute a bash into running Docker containers.

Sometimes when you are running docker containers, you need to inspect the status of services, files, configurations, this gem provides the ability to log into running containers using a GNU Bourne-Shell and debug the container from another shell

## Requirements

This command line tool has been developed and tested on Gnu/Linux environments, it won't run on Darwin (Mac OS X) systems.

In order to run dockerbash, you must set and use properly the DOCKER_OPTS value on your system

```
$ vim /etc/default/docker
DOCKER_OPTS='-H tcp://0.0.0.0:4243 -H unix:///var/run/docker.sock'

$ service docker restart
```

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'dockerbash'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install dockerbash

## Usage
How to run it:

```  
$ dockerbash
```  

Example menu:

```
     _            _             _               _
  __| | ___   ___| | _____ _ __| |__   __ _ ___| |___
 / _` |/ _ \ / __| |/ / _ \  __|  _ \ / _` / __|  _  \
| (_| | (_) | (__|   <  __/ |  | |_) | (_| \__ \ | | |
 \__,_|\___/ \___|_|\_\___|_|  |_.__/ \__,_|___/_| |_|
 
                                             by m8051.
                                             
0. Container: docker_nginx_1	 IP: 172.17.0.3	 Started At: 2016-04-25 - 21:26:55.461611217Z
1. Container: docker_php7-fpm_1	 IP: 172.17.0.2	 Started At: 2016-04-25 - 21:26:54.784825954Z
Container?  0

root@2d7083aa1744:/
```                                          
## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/dockerbash. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).



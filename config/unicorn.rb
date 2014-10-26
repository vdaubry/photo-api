# Ensure that we're running in the production environment
env = ENV['RACK_ENV'] || 'production'

# config/unicorn.rb
worker_processes Integer(ENV["WEB_CONCURRENCY"] || 2)
timeout 30
preload_app true

# Production specific settings 

if env == "production"
  # listen on both a Unix domain socket and a TCP port,
  # we use a shorter backlog for quicker failover when busy

  listen "/tmp/unicorn.photo-api.sock", backlog: 64

  pid "/srv/www/photo-api/shared/pids/unicorn.pid"

  # feel free to point this anywhere accessible on the filesystem
  #user 'deploy'
  current_path = "/srv/www/photo-api/current"
  stderr_path "#{current_path}/log/unicorn.log"
  stdout_path "#{current_path}/log/unicorn.log"

  # Help ensure your application will always spawn in the symlinked
  # "current" directory that Capistrano sets up. 
  working_directory "#{current_path}"

end

before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.connection.disconnect!
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end

  defined?(ActiveRecord::Base) and
    ActiveRecord::Base.establish_connection
end
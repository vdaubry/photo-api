# config/unicorn.rb
worker_processes Integer(ENV["WEB_CONCURRENCY"] || 3)
timeout 30
preload_app true

# Production specific settings 

if env == "production"
  # listen on both a Unix domain socket and a TCP port,
  # we use a shorter backlog for quicker failover when busy

  listen "/tmp/unicorn.photo-visualizer.sock", backlog: 64

  # Help ensure your application will always spawn in the symlinked
  # "current" directory that Capistrano sets up. 
  working_directory "/home/deployer/apps/my_site/current"

  # feel free to point this anywhere accessible on the filesystem
  #user 'deploy'
  current_path = "/srv/www/photo-visualizer/current"
  stderr_path "#{current_path}/log/unicorn.log"
  stdout_path "#{current_path}/log/unicorn.log"
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
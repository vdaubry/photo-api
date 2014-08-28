rails_env   = ENV['RAILS_ENV']  || "production"
rails_root  = ENV['RAILS_ROOT'] || "/srv/www/photo-api/current"
 
God.watch do |w|
  w.name          = "resque-scheduler"
  w.group         = 'resque'
  w.interval      = 30.seconds
  w.dir           = rails_root
  w.env           = { 'RAILS_ENV' => rails_env }
  w.start         = "bundle exec rake resque:scheduler"
  w.start_grace   = 10.seconds
  w.log           = File.join(rails_root, 'log', 'resque-scheduler.log')
 
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 5.seconds
      c.running = false
    end
  end

  w.transition(:up, :restart) do |on|
      # restart if server is restarted
      on.condition(:file_touched) do |c|
        c.interval = 5.seconds
        c.path = File.join(rails_root, 'tmp', 'restart.txt')
      end
    end
end
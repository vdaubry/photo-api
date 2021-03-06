rails_env   = ENV['RAILS_ENV']  || "production"
rails_root  = ENV['RAILS_ROOT'] || "/srv/www/photo-api/current"
num_workers = 0
 
num_workers.times do |num|
  God.watch do |w|
    w.name          = "resque-#{num}"
    w.group         = 'resque'
    w.interval      = 30.seconds
    w.env           = { 'RAILS_ENV' => rails_env, 'QUEUE' => '*' }
    w.dir           = rails_root
    w.start         = "bundle exec rake resque:work"
    w.start_grace   = 10.seconds
    w.log           = File.join(rails_root, 'log', 'resque.log')
 
    # restart if memory gets too high
    w.transition(:up, :restart) do |on|
      on.condition(:memory_usage) do |c|
        c.above = 100.megabytes
        c.times = 2
      end
    end
 
    # determine the state on startup
    w.transition(:init, { true => :up, false => :start }) do |on|
      on.condition(:process_running) do |c|
        c.running = true
      end
    end
 
    # determine when process has finished starting
    w.transition([:start, :restart], :up) do |on|
      on.condition(:process_running) do |c|
        c.running = true
        c.interval = 5.seconds
      end
 
      # failsafe
      on.condition(:tries) do |c|
        c.times = 5
        c.transition = :start
        c.interval = 5.seconds
      end
    end
 
    # start if process is not running
    w.transition(:up, :start) do |on|
      on.condition(:process_running) do |c|
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
end
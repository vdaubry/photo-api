rails_env   = ENV['RAILS_ENV']  || "production"
rails_root  = ENV['RAILS_ROOT'] || "/srv/www/photo-api/current"
 
God.watch do |w|
  w.name          = "zipper-done"
  w.group         = 'zipper'
  w.interval      = 30.seconds
  w.dir           = rails_root
  w.env           = { 'RAILS_ENV' => rails_env, 'AWS_ACCESS_KEY_ID' => AWS_ACCESS_KEY_ID, 'AWS_SECRET_ACCESS_KEY' => AWS_SECRET_ACCESS_KEY}
  w.start         = "bundle exec rake zip:listen"
  w.uid           = 'deploy'
  w.gid           = 'deploy'
  w.start_grace   = 10.seconds
  w.log           = File.join(rails_root, 'log', 'zipper-done.log')
 
  w.start_if do |start|
    start.condition(:process_running) do |c|
      c.interval = 5.seconds
      c.running = false
    end
  end

  # restart if memory gets too high
  w.transition(:up, :restart) do |on|
    on.condition(:memory_usage) do |c|
      c.above = 100.megabytes
      c.times = 2
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
uri = Rails.env.test? ? URI.parse("redis://127.0.0.1:6379") : URI.parse(ENV["REDISTOGO_URL"]) 
Resque.redis = Redis.new(:host => uri.host, :port => uri.port, :password => uri.password, :thread_safe => true)
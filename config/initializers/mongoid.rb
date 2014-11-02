#Mogoid does not load config/mongoid.yml in development (!?*#@)
Mongoid.load!(Rails.root.join("config/mongoid.yml")) if Rails.env.development?
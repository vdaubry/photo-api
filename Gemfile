source 'https://rubygems.org'

gem 'rails',                    '4.0.4'
gem 'mongoid',                  git: 'git://github.com/mongoid/mongoid.git'
gem 'figaro',                   '~> 0.7.0'
gem 'active_model_serializers', '~> 0.8.1'
gem 'kaminari',                 '~> 0.15.1'
gem 'newrelic_rpm',             '~> 3.7.3.204'
gem 'unicorn',                  '~> 4.8.2'
gem 'net-sftp',                 '~> 2.1.2'

group :test do
  gem 'coveralls',              '~> 0.7.0', require: false
  gem "mocha",                  '~> 1.0.0'
  gem "rspec-rails",            '~> 2.14.1'
  gem 'factory_girl_rails',     '~> 4.4.1'
end

group :development do
    gem 'capistrano',           '~> 3.1.0'
end

group :development, :test do
  gem 'debugger'
end

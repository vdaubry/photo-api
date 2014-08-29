source 'https://rubygems.org'

gem 'rails',                      '~> 4.1.4'
gem 'mongoid',                    git: 'git://github.com/mongoid/mongoid.git'
gem 'figaro',                     '~> 0.7.0'
gem 'active_model_serializers',   '~> 0.8.1'
gem 'kaminari',                   '~> 0.16.1'
gem 'newrelic_rpm',               '~> 3.9.1.236'
gem 'unicorn',                    '~> 4.8.3'
gem 'net-sftp',                   '~> 2.1.2'
gem 'sentry-raven',               '~> 0.9.4'
gem 'librato-rails',              '~> 0.11.1'
gem 'resque',                     '~> 1.25.2'
gem 'resque-web',                 '~> 0.0.6'
gem 'resque-scheduler',           '~> 3.0.0'
gem 'devise',                     '~> 3.3.0'
  
group :test do  
  gem 'coveralls',                '~> 0.7.0', require: false
  gem 'mocha',                    '~> 1.1.0'
  gem 'rspec-rails',              '~> 3.0.2'
  gem 'factory_girl_rails',       '~> 4.4.1'
end

group :development do
    gem 'capistrano-rails',       '~> 1.1.1'
    gem 'capistrano-bundler',     '~> 1.1.3'
    gem "spring-commands-rspec",  '~> 1.0.2'
end

group :development, :test do
  gem 'byebug'
end

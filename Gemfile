source 'https://rubygems.org'

gem 'rails',                    '4.0.3'
gem 'mongoid',                  git: 'git://github.com/mongoid/mongoid.git'
gem 'figaro',                   '~> 0.7.0'
gem 'active_model_serializers', '~> 0.8.1'
gem 'kaminari',                 '~> 0.15.1'
gem 'newrelic_rpm',             '~> 3.7.2.195'
gem 'unicorn',                  '~> 4.8.2'

group :test do
  gem 'coveralls',              '~> 0.7.0', require: false
  gem "mocha",                  '~> 1.0.0'
  gem "rspec-rails",            '~> 2.14.1'
  gem 'factory_girl_rails',     '~> 4.4.1'
end

group :development, :test do
  gem 'debugger'
end

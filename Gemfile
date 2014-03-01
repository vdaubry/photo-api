source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.0.3'

# See https://github.com/sstephenson/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby

gem 'mongoid', git: 'git://github.com/mongoid/mongoid.git'

gem 'mail', git: 'git://github.com/pwnall/mail', :ref => 'd367c0827b10161d7cc42fd22237daa9a7cedafd' #Fixes mail dependency with mimetypes 1.x which conflicts with Mechanize dependency on mimetypes 2.x => https://github.com/mikel/mail/issues/641

gem 'net-sftp', '~> 2.1.2'
gem 'figaro', '~> 0.7.0'
gem 'active_model_serializers', '~> 0.8.1'
gem 'mechanize', '~> 2.7.3'
gem 'fastimage', '~> 1.6.1'
gem 'mini_magick', '~> 3.7.0'
gem 'kaminari', '~> 0.15.1'
gem 'newrelic_rpm', '~> 3.7.2.195'
gem 'open_uri_redirections', '~> 0.1.4'
gem 'unicorn', '~> 4.8.2'

group :doc do
  # bundle exec rake doc:rails generates the API under doc/api.
  gem 'sdoc', require: false
end

group :development do
  gem "spring-commands-rspec", :require => false
end

group :test do
  gem "mocha", '~> 1.0.0'
  gem "rspec-rails", '~> 2.14.1'
  gem 'factory_girl_rails', '~> 4.4.1'
end

# Use ActiveModel has_secure_password
# gem 'bcrypt-ruby', '~> 3.1.2'

# Use unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano', group: :development

# Use debugger
# gem 'debugger', group: [:development, :test]

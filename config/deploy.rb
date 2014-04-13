# Ensure that bundle is used for rake tasks
SSHKit.config.command_map[:rake] = "bundle exec rake"

# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'photo-visualizer'
set :repo_url, 'git@github.com:vdaubry/photo-downloader.git'
set :branch, "master"
set :deploy_via, :remote_cache
set :ssh_options, { :forward_agent => true }

# We are only going to use a single stage: production
set :stages, ["production"]

# Default branch is :master
# ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default deploy_to directory is /var/www/my_app
set :deploy_to, '/srv/www/photo-visualizer'

# Default value for :scm is :git
# set :scm, :git

# Default value for :format is :pretty
# set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
# set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
# set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 1

#set :rvm_ruby_string, :local              # use the same ruby as used locally for deployment

namespace :deploy do

  desc "Check that we can access everything"
  task :check_write_permissions do
    on roles(:all) do |host|
      if test("[ -w #{fetch(:deploy_to)} ]")
        info "#{fetch(:deploy_to)} is writable on #{host}"
      else
        error "#{fetch(:deploy_to)} is not writable on #{host}"
      end
    end
  end

  desc 'Copy config from local workstation'
  task :copy_production do
    on roles :all do
      execute :mkdir, '-p', "#{shared_path}/config"
      upload! 'config/initializers/secret_token.rb', "#{release_path}/config/initializers/secret_token.rb"
      upload! 'config/application.yml', "#{release_path}/config/application.yml"
      upload! 'config/librato.yml', "#{release_path}/config/librato.yml"
    end
  end

  desc 'Start unicorn'
  task :start do
    on roles(:app), in: :sequence, wait: 5 do
      execute :mkdir, '-p', "#{shared_path}/pids"
      execute "cd #{current_path} && bundle exec unicorn -p 3002 -c ./config/unicorn.rb -E production -D"
    end
  end

  desc 'Stop unicorn'
  task :stop do
    on roles(:app) do
      #kill process saved in unicorn.pid and ignore errors
      execute "kill -s QUIT `cat #{shared_path}/pids/unicorn.pid` || true"
    end
  end

  desc 'Run migration'
  task :invoke do  
    run("cd #{current_path}; rake migration:run")  
  end  
  

  before :compile_assets, :copy_production
  after :publishing, :stop
  after :publishing, :start
  after :published, :start

  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

end

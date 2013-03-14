require 'bundler/capistrano'
# set :whenever_command, "bundle exec whenever"
# require "whenever/capistrano"

# Load RVM's capistrano plugin.    
require 'rvm/capistrano'
set :rvm_ruby_string, 'ruby-1.9.3-p392'
set :rvm_type, :system

set :stages, %w(production qa)
set :default_stage, "production"
require 'capistrano/ext/multistage'

# set :server, 'virpus'
set :application, 'expo_proyecto'

set :scm, :git
set :repository, 'https://github.com/cristianrasch/expo_proyecto.git'

# set :user, 'ec2-user'
set :use_sudo, false
set :deploy_via, :remote_cache

set :target_host, "virpus"
# role :web, target_host                          # Your HTTP server, Apache/etc
role :app, target_host                          # This may be the same as your `Web` server
role :db,  target_host, :primary => true        # This is where Rails migrations will run

desc "Symlink the database config file from shared
      directory to current release directory."
task :symlink_database_yml, :roles => :app do
  run "ln -nsf #{shared_path}/config/database.yml
      #{release_path}/config/database.yml"
end
after 'deploy:update_code', 'symlink_database_yml'

desc "Symlink the config.local.yml file from shared
      directory to current release directory."
task :symlink_config_local_yml, :roles => :app do
  run "ln -nsf #{shared_path}/config/config.local.yml
      #{release_path}/config/config.local.yml"
end
after 'deploy:update_code', 'symlink_config_local_yml'

namespace(:deploy) do
  desc 'Restart the app server'
  task :restart, :roles => :app do
    run "touch #{current_path}/tmp/restart.txt"
  end
end
after 'deploy', 'deploy:cleanup'

require 'bundler/capistrano'
# set :whenever_command, "bundle exec whenever"
# require "whenever/capistrano"

# Add RVM's lib directory to the load path.
$:.unshift(File.expand_path('./lib', ENV['rvm_path']))

# Load RVM's capistrano plugin.    
require "rvm/capistrano"

set :rvm_ruby_string, 'ruby-1.9.2-p290'
# set :rvm_type, :user  # Don't use system-wide RVM

set :application, "expo_proyecto"

set :scm, :git
set :repository,  "git@github.com:cristianrasch/expo_proyecto.git"

# set :user, 'ec2-user'
set :use_sudo, false
set :deploy_via, :remote_cache
set :deploy_to, "/var/www/#{application}"

role :web, "ec2"                          # Your HTTP server, Apache/etc
role :app, "ec2"                          # This may be the same as your `Web` server
role :db,  "ec2", :primary => true        # This is where Rails migrations will run

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

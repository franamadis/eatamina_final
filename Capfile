# Load DSL and Setup Up Stages
require 'capistrano/setup'

require 'capistrano/deploy'
require "capistrano/scm/git"
install_plugin Capistrano::SCM::Git

require 'capistrano/rails'
require 'capistrano/passenger'
require 'capistrano/bundler'
require 'capistrano/rbenv'
set :rbenv_type, :user
set :rbenv_ruby, '2.4.4'
# require 'capistrano/rvm'
require 'capistrano/puma'
install_plugin Capistrano::Puma

# Loads custom tasks from `lib/capistrano/tasks' if you have any defined.
Dir.glob('lib/capistrano/tasks/*.rake').each { |r| import r }
# Add your own tasks in files placed in lib/tasks ending in .rake,
# for example lib/tasks/capistrano.rake, and they will automatically be available to Rake.

require_relative "config/application"
require 'rubocop/rake_task'

RuboCop::RakeTask.new(:rubocop)
task default: [:rubocop]

Rails.application.load_tasks

#!/usr/bin/env rake

require 'foodcritic'

# FC041 is excluded because we want to preserve the official RVM installation
# process as much as possible, i.e. using curl to download the installer.
FoodCritic::Rake::LintTask.new do |t|
  t.options = { :fail_tags => ['any'], :tags => ['~FC041'] }
end

begin
  require 'jamie/rake_tasks'
  Jamie::RakeTasks.new
rescue LoadError
  puts ">>>>> Jamie gem not loaded, omitting tasks" unless ENV['CI']
end

task :default => [:foodcritic]

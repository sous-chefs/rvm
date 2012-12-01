#!/usr/bin/env rake

require 'foodcritic'
require_relative 'test/jamie/rake_task'

FoodCritic::Rake::LintTask.new do |t|
  t.options = { :fail_tags => ['any'] }
end

Jamie::Rake::Tasks.new

task :default => [:foodcritic]

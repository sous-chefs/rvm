source 'https://rubygems.org'

gem 'rake'
gem 'minitest'
gem 'foodcritic', :platforms => :ruby_19

# allow CI to override the version of Chef for matrix testing
gem 'chef', (ENV['CHEF_VERSION'] || '>= 0.10.10')

group :integration do
  gem 'berkshelf', '>= 1.0.0'
  gem 'jamie', :git => 'git://github.com/jamie-ci/jamie.git'
end

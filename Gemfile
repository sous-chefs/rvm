source 'https://rubygems.org'

gem 'rake'
gem 'foodcritic'
gem 'minitest'

# allow CI to override the version of Chef for matrix testing
gem 'chef', (ENV['CHEF_VERSION'] || '>= 0.10.10')

group :integration do
  gem 'berkshelf'
  gem 'test-kitchen',    :git => 'git://github.com/opscode/test-kitchen.git', :ref => '1.0'
  gem 'kitchen-vagrant', :git => 'git://github.com/opscode/kitchen-vagrant.git'
end

source 'https://rubygems.org'

gem 'foodcritic', '~> 3.0.3'
gem 'minitest'
gem 'rake'
gem 'rspec'
gem 'guard-rspec'

# allow CI to override the version of Chef for matrix testing
gem 'chef', (ENV['CHEF_VERSION'] || '>= 0.10.10')

group :integration do
  gem 'berkshelf', '~> 2.0.10'
  gem 'test-kitchen', '~> 1.1.1'
  gem 'kitchen-vagrant', '~> 0.14.0'
end

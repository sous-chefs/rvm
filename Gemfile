source 'https://rubygems.org'

gem 'foodcritic'
gem 'minitest'
gem 'rake'
gem 'rspec'
gem 'guard-rspec'

# allow CI to override the version of Chef for matrix testing
gem 'chef', (ENV['CHEF_VERSION'] || '>= 0.10.10')

group :integration do
  gem 'berkshelf', '~> 2.0'
  gem 'test-kitchen', '~> 1.0.0.beta.3'
  gem 'kitchen-vagrant'
end

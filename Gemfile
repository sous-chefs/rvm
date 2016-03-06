source 'https://rubygems.org'

# allow CI to override the version of Chef for matrix testing
gem 'chef', (ENV['CHEF_VERSION'] || '>= 11.14.0')

gem 'rake'
gem 'guard-rspec'

group :development do
  gem 'emeril'
end

group :lint do
  gem 'foodcritic', '~> 6.0'
  gem 'rubocop', '~> 0.37'
end

group :unit do
  gem 'berkshelf', '~> 4.1'
  gem 'chefspec', '~> 4.5'
end

group :kitchen_common do
  gem 'test-kitchen', '~> 1.5'
end

group :kitchen_vagrant do
  gem 'kitchen-vagrant', '~> 0.19'
end

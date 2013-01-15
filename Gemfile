source 'https://rubygems.org'

gem 'rake'
gem 'foodcritic'

# allow CI to override the version of Chef for matrix testing
gem 'chef', (ENV['CHEF_VERSION'] || '>= 0.10.10')

gem 'moneta', '< 0.7.0'

group :integration do
  gem 'berkshelf'
  gem 'jamie', '~> 0.1.0.beta3'
  gem 'jamie-vagrant'
end

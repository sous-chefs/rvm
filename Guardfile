guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^(recipes)/(.+)\.rb$})    { |m| "spec/recipes/#{m[1]}_spec.rb" }
  watch(%r{^(libraries)/(.+)\.rb$})  { |m| "spec/libraries/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')       { 'spec' }
end

guard :foodcritic, cli: "-X 'test/**/*' -X 'spec/**/*'", cookbook_paths: '.' do
  watch(%r{^attributes/.+\.rb$})
  watch(%r{^libraries/.+\.rb$})
  watch(%r{^recipes/.+\.rb$})
  watch('metadata.rb')
end

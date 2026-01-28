guard :rspec, cmd: 'chef exec rspec' do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^resources/(.+)\.rb$})    { |m| "spec/resources/#{m[1]}_spec.rb" }
  watch(%r{^libraries/(.+)\.rb$})    { |m| "spec/libraries/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')       { 'spec' }
end

guard :rubocop, all_on_start: false, cli: ['--display-cop-names'] do
  watch(%r{^attributes/.+\.rb$})
  watch(%r{^libraries/.+\.rb$})
  watch(%r{^resources/.+\.rb$})
  watch(%r{^spec/.+\.rb$})
  watch('metadata.rb')
  watch('.rubocop.yml')
end

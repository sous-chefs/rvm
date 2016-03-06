guard :rspec do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^(recipes)/(.+)\.rb$})     { |m| "spec/#{m[1]}_spec.rb" }
  watch('spec/spec_helper.rb')  { 'spec' }
end

guard :foodcritic, cookbook_paths: '.' do
  watch(%r{attributes/.+\.rb$})
  watch(%r{libraries/.+\.rb$})
  watch(%r{recipes/.+\.rb$})
end

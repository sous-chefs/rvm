require 'chefspec'

# Only load Berkshelf for specs that need it (resource specs)
# Library:: specs don't need cookbook vendoring
if ENV['BERKSHELF'] == 'true'
  require 'chefspec/berkshelf'
end

RSpec.configure do |config|
  config.platform = 'ubuntu'
  config.version = '22.04'
  config.log_level = :error
end

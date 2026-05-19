# frozen_string_literal: true

require 'chefspec'
require 'fileutils'
require 'tmpdir'

module ChefSpec
  class ZeroServer
    def setup; end
    def setup!; end
    def reset!; end
    def teardown!; end
  end
end

RSpec.configure do |config|
  cookbook_root = File.join(Dir.tmpdir, 'rvm-chefspec-cookbooks')
  FileUtils.mkdir_p(cookbook_root)
  FileUtils.ln_sf(File.expand_path('..', __dir__), File.join(cookbook_root, 'rvm'))
  FileUtils.ln_sf(File.expand_path('../test/cookbooks/test', __dir__), File.join(cookbook_root, 'test'))

  config.platform = 'ubuntu'
  config.version = '22.04'
  config.log_level = :error
  config.cookbook_path = [cookbook_root]
end

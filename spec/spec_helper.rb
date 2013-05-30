require 'berkshelf'
require 'chefspec'

berksfile = Berkshelf::Berksfile.from_file(File.expand_path('Berksfile'))
berksfile.install(path: 'vendor/cookbooks')

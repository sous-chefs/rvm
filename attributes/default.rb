default[:rvm][:root_path] = "/usr/local/rvm"
default[:rvm][:group_users] = []
default[:rvm][:rvmrc] = Hash.new

# ruby that will get set to `rvm use default`. Use fully qualified ruby names.
default[:rvm][:default_ruby] = "ree-1.8.7-2010.02"

# list of rubies that will be installed
default[:rvm][:rubies] = [ rvm[:default_ruby] ]

# hash of gemsets and their list of gems to be installed
default[:rvm][:gems] = {
  "#{rvm[:default_ruby]}@global" => [
    { :name => "bundler" }
  ]
}


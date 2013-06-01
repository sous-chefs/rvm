def whyrun_supported?
  false
end

action :create do
  alias_name = new_resource.alias_name
  version = new_resource.version

  unless alias_exists(alias_name, version)
    Chef::Log.info(">> adding rvm alias #{alias_name} => #{version}")
    rvm_shell "Create RVM Alias #{alias_name}" do
      code    %(rvm alias create #{alias_name} #{version})
      path    ["#{node['rvm']['root_path']}/bin"]
    end

    new_resource.updated_by_last_action(true)
  end
end

action :delete do
  alias_name = new_resource.alias_name
  version = new_resource.version

  if alias_exists(alias_name, version)
    Chef::Log.info(">> removing rvm alias #{alias_name} => #{version}")
    rvm_shell "Delete RVM Alias #{alias_name}" do
      code    %(rvm alias delete #{alias_name} #{version})
      path    ["#{node['rvm']['root_path']}/bin"]
    end

    new_resource.updated_by_last_action(true)
  end
end

def alias_exists(alias_name, version)
  command = Mixlib::ShellOut.new("rvm alias show #{alias_name} | grep '^#{version}'")
  command.run_command

  command.exitstatus == 0
end

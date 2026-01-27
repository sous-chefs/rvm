# Make sure Vagrant user is on the box. This should fix the dokken user install
user 'vagrant'

group 'vagrant' do
  members 'vagrant'
end

directory '/home/vagrant' do
  owner 'vagrant'
  group 'vagrant'
  not_if { platform?('windows') }
end

# Grant vagrant user passwordless sudo for package management
# RVM needs this to install system dependencies when installing Ruby
# Disable requiretty for non-interactive sudo commands
file '/etc/sudoers.d/vagrant' do
  content "Defaults:vagrant !requiretty\nvagrant ALL=(ALL) NOPASSWD: ALL\n"
  mode '0440'
  owner 'root'
  group 'root'
end

group 'rvm' do
  members ['vagrant']
  append  true
end

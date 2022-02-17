version = '2.4.1'

# Make sure that Vagarant user is on the box for dokken
include_recipe 'test::dokken'

rbenv_user_install 'vagrant'

rbenv_system_install 'system'

rbenv_ruby version do
  install_ruby_build false
  user 'vagrant'
end

rbenv_global version do
  user 'vagrant'
end

rbenv_plugin 'ruby-build' do
  git_url 'https://github.com/rbenv/ruby-build.git'
  user 'vagrant'
end

# This should get installed to the system_install
rbenv_plugin 'user-gems' do
  git_url 'git@github.com:mislav/rbenv-user-gems.git'
  git_ref 'v1.0.1'
end


if defined?(ChefSpec)
  def install_rvm_ruby(resource_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rvm_ruby, :install, resource_name)
  end
end
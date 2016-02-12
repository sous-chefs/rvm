if defined?(ChefSpec)

  def upgrade_rvm_gem(gem_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rvm_gem, :upgrade, gem_name)
  end

  def install_rvm_gem(gem_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rvm_gem, :install, gem_name)
  end

  def remove_rvm_gem(gem_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rvm_gem, :remove, gem_name)
  end

  def purge_rvm_gem(gem_name)
    ChefSpec::Matchers::ResourceMatcher.new(:rvm_gem, :purge, gem_name)
  end


end

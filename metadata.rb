maintainer       "Fletcher Nichol"
maintainer_email "fnichol@nichol.ca"
license          "Apache 2.0"
description      "Installs/Configures rvm"
long_description IO.read(File.join(File.dirname(__FILE__), 'README.rdoc'))
version          "0.1"

recipe "rvm",               "Includes all recipes"
recipe "rvm::system",       "Installs system-wide RVM"
recipe "rvm::rubies",       "Installs RVM rubies"
recipe "rvm::default_ruby", "Sets a default RVM ruby"

%w{ ubuntu }.each do |os|
  supports os
end

attribute "rvm/root_path",
  :display_name => "RVM root path",
  :description => "Root path for RVM installation",
  :default => "/usr/local/rvm"

attribute "rvm/default_ruby",
  :display_name => "Default ruby",
  :description => "Default ruby for new shells",
  :default => "ree"

attribute "rvm/rubies",
  :display_name => "Installed RVM rubies",
  :description => "Set of rubites that RVM will manage",
  :type => "array",
  :default => [ "ree" ]


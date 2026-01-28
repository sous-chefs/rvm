# Shared user property for resources that can operate on system or user RVM
property :user,
         String,
         description: 'User to install RVM for. If not specified, installs system-wide.'

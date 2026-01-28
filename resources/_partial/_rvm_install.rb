# Shared properties for RVM installation resources
property :installer_url,
         String,
         default: 'https://raw.githubusercontent.com/rvm/rvm/master/binscripts/rvm-installer',
         description: 'URL to the RVM installer script'

property :version,
         String,
         default: 'stable',
         description: 'RVM version to install (stable, latest, head, or specific version)'

property :autolib_mode,
         [Integer, String],
         default: 3,
         description: 'RVM autolibs mode (0-4 or disable, read-only, read-fail, packages, enable)'

property :rvmrc_env,
         Hash,
         default: { 'rvm_gem_options' => '--no-document' },
         description: 'Hash of rvmrc environment options'

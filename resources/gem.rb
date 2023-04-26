unified_mode true

property :package_name,
          String,
          name_property: true

property :version,
          String

property :ruby_string,
          String,
          default: 'default'

property :response_file,
          String

property :source,
          String

property :options,
          Hash

property :gem_binary,
          String

property :user,
          String

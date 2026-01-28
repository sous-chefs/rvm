# Shared GPG properties for RVM installation resources
property :gpg_key,
         String,
         default: '409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB',
         description: 'GPG key fingerprints for RVM verification'

property :keyserver,
         String,
         default: 'hkp://keyserver.ubuntu.com',
         description: 'GPG keyserver to fetch keys from'

require 'spec_helper'

# NOTE: Resource specs that step into custom resources require extensive stubbing
# of RVM commands and external dependencies (gpg cookbook). These resources are
# better tested via integration tests (Test Kitchen).
#
# The RvmHelper library is tested in spec/libraries/rvm_helper_spec.rb

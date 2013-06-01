actions :create, :delete

attribute :alias_name, :kind_of => String, :name_attribute => true
attribute :version, :kind_of => String

def initialize(*args)
  super
  @action = :create
end

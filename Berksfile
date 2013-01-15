site :opscode

metadata

group :integration do
  cookbook 'apt'
  cookbook 'yum'
  # pending merging of http://tickets.opscode.com/browse/COOK-2205
  cookbook 'java',            :git => 'git://github.com/crahan/java.git',
                              :ref => 'default_java_fix'
  cookbook 'user'
end

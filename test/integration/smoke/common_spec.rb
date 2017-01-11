# Version
describe command('ruby --version') do
  its(:exit_status) { should eq 0 }
  its(:stdout) { should match(/ruby 2.1.8p440/) }
  its(:stderr) { should eq '' }
end

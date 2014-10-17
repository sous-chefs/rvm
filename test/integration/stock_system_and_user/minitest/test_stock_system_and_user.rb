require "minitest/autorun"
require "minitest/pride"
require "mixlib/shellout"

def exec_with_env(cmd, user="root")
  home_dir = etc_user(user).dir
  opts = {
    :user => user,
    :group => etc_user(user).gid,
    :cwd => home_dir,
    :env => { "HOME" => home_dir,
              "USER" => user,
              "TERM" => "dumb" }
  }
  exec_cmd = Mixlib::ShellOut.new(%{#{cmd}}, opts)
  exec_cmd.run_command
  exec_cmd
end

def exec_with_rvm(cmd, user="root")
  exec_with_env(%{#{rvm_path(user)}/bin/rvm #{cmd}}, user)
end

def rvm_path(user="root")
  if user == "root"
    "/usr/local/rvm"
  else
    ::File.join(etc_user(user).dir, ".rvm")
  end
end

def etc_user(user="root")
  Etc.getpwnam(user)
end

describe "A system installation" do
  it "creates a system install RVM directory" do
    assert File.exists?("/usr/local/rvm")
  end

  it "sources into environment" do
    assert_nil exec_with_env("bash -lc 'type rvm 1>/dev/null 2>&1'").error!
  end

  it "installs 2.1.3" do
    assert_match(/2\.1\.3/,exec_with_rvm("list strings", "wigglebottom").stdout)
  end
end

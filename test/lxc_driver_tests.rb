require "minitest/spec"
require "minitest/autorun"

require File.join(File.dirname(__FILE__), "..", "lib", "jamie", "driver", "lxc")

describe Jamie::Driver::LXC do

  before do
    @lxc = Jamie::Driver::LXC.new
  end

  it "can clone a base lxc container" do
    state = Hash.new
    @lxc.perform_create("ubuntu-12.04", state)
    state.must_include("name")
    state.must_include("hostname")
  end

end

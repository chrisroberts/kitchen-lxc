require "minitest/spec"
require "minitest/autorun"

require File.join(File.dirname(__FILE__), "..", "lib", "jamie", "driver", "lxc")

describe Jamie::Driver::LXC do

  before do
    @lxc = Jamie::Driver::LXC.new
    @instance = Jamie::Instance.new
    @instance.name = "iac-testing"
  end

  it "can clone a base lxc container" do
    state = Hash.new
    @lxc.perform_create(@instance, state)
    puts state.inspect
    state.must_include("name")
    state.must_include("hostname")
    @lxc.perform_destroy(@instance, state)
  end

end

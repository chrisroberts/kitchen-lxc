require "minitest/spec"
require "minitest/autorun"

require File.join(File.dirname(__FILE__), "..", "lib", "jamie", "driver", "lxc")

describe Jamie::Driver::LXC do

  before do
    suite = Jamie::Suite.new("name" => "test", "run_list" => Array.new)
    config = {
      "jamie_root" => File.dirname(__FILE__),
      "base_container" => "iac-testing"
    }
    driver = Jamie::Driver::LXC.new(config)
    platform = Jamie::Platform.new("name" => "ubuntu-12.04", "driver" => driver)
    @instance = Jamie::Instance.new(suite, platform)
  end

  it "can clone a base lxc container" do
    @instance.create
    @instance.destroy
  end

end

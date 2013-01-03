require "minitest/spec"
require "minitest/autorun"
require "stringio"

require File.join(File.dirname(__FILE__), "..", "lib", "jamie", "driver", "lxc")

describe Jamie::Driver::Lxc do

  before do
    suite = Jamie::Suite.new("name" => "test", "run_list" => Array.new)
    config = {
      "jamie_root" => File.dirname(__FILE__),
      "base_container" => "ubuntu-1204"
    }
    driver = Jamie::Driver::Lxc.new(config)
    platform = Jamie::Platform.new("name" => "ubuntu-1204")
    @logger_output = StringIO.new
    logger = Jamie::Logger.new(:stdout => @logger_output)
    options = {
      "suite" => suite,
      "platform" => platform,
      "driver" => driver,
      "jr" => "jr",
      "logger" => logger
    }
    @instance = Jamie::Instance.new(options)
  end

  it "can clone a base lxc container" do
    @instance.create
    @instance.destroy
  end

end

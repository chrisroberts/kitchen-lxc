require "minitest/spec"
require "minitest/autorun"
require "stringio"

require File.join(File.dirname(__FILE__), "..", "lib", "jamie", "driver", "lxc")

describe Jamie::Driver::Lxc do

  before do
    @logger_output = StringIO.new
    driver_options = {
      :jamie_root      => File.dirname(__FILE__),
      :base_container  => "ubuntu-1204"
    }
    instance_options = {
      :logger    => Jamie::Logger.new(:stdout => @logger_output),
      :suite     => Jamie::Suite.new(:name => "test", :run_list => Array.new),
      :platform  => Jamie::Platform.new(:name => "ubuntu-1204"),
      :driver    => Jamie::Driver::Lxc.new(driver_options),
      :jr        => Jamie::Jr.new("test")
    }
    @instance = Jamie::Instance.new(instance_options)
  end

  it "can clone a base lxc container" do
    @instance.create
    @logger_output.string.must_match(/Finished creating <test-ubuntu-1204> complete/i)
    @instance.destroy
    @logger_output.string.must_match(/Finished destroying of <test-ubuntu-1204> complete/i)
  end

end

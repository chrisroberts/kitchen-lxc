require "minitest/spec"
require "minitest/autorun"
require "stringio"

require File.join(File.dirname(__FILE__), "..", "lib", "kitchen", "driver", "lxc")

describe Kitchen::Driver::Lxc do

  before do
    @logger_output = StringIO.new
    driver_options = {
      :kitchen_root      => File.dirname(__FILE__),
      :base_container  => "ubuntu-1204"
    }
    instance_options = {
      :logger    => Kitchen::Logger.new(:stdout => @logger_output),
      :suite     => Kitchen::Suite.new(:name => "test", :run_list => Array.new),
      :platform  => Kitchen::Platform.new(:name => "ubuntu-1204"),
      :driver    => Kitchen::Driver::Lxc.new(driver_options),
      :jr        => Kitchen::Jr.new("test")
    }
    @instance = Kitchen::Instance.new(instance_options)
  end

  it "can clone a base lxc container" do
    @instance.create
    @logger_output.string.must_match(/Finished creating <test-ubuntu-1204>/i)
    @instance.destroy
    @logger_output.string.must_match(/Finished destroying <test-ubuntu-1204>/i)
  end

end

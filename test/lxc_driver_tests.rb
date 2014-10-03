require "minitest/spec"
require "minitest/autorun"
require "stringio"
require 'ostruct'

require File.join(File.dirname(__FILE__), "..", "lib", "kitchen", "driver", "lxc")

describe Kitchen::Driver::Lxc do

  before do
    driver_options = {
      :kitchen_root   => File.dirname(__FILE__),
    }
    @logger_output = StringIO.new
    instance_options = {
      :logger   => Kitchen::Logger.new(:stdout => @logger_output),
      :suite    => Kitchen::Suite.new(:name => "test", :run_list => Array.new),
      :platform => Kitchen::Platform.new(:name => @base_container),
      :driver   => Kitchen::Driver::Lxc.new(driver_options),
      :provisioner => Kitchen::Provisioner::Base.new,
      :busser => Object.new,
      :state_file => Kitchen::StateFile.new('default', OpenStruct.new(:name => 'ubuntu'))#Kitchen::Busser
    }
    @instance = Kitchen::Instance.new(instance_options)
  end

  it "can clone a base lxc container" do
    @instance.create
    container_name = "test-#{@base_container}"
    @logger_output.string.must_match(/Finished creating <#{container_name}>/i)
    @instance.destroy
    @logger_output.string.must_match(/Finished destroying <#{container_name}>/i)
  end

end

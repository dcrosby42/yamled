require 'spec_helper'

class YamledTestDriver
  def self.run(stdin_data=nil,arg_string=nil)
    new(stdin_data,arg_string)
  end

  attr_reader :exit_status, :stdout, :stderr

  def initialize(stdin_data=nil,arg_string=nil)
    require 'open3'
    cmd = "#{PROJ_ROOT}/bin/yamled"
    if arg_string
      cmd += " #{arg_string}"
    end
    @stdout, @stderr, status = Open3.capture3(cmd, stdin_data: stdin_data)
    @exit_status = status.exitstatus
  end
end

def read_test_file(fname)
  full_fname = "#{PROJ_ROOT}/spec/system/data/#{fname}"
  File.read(full_fname)
end


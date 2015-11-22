PROJ_ROOT = File.expand_path(File.dirname(__FILE__) + "/..")

require 'yaml'


def to_yaml(data)
  YAML.dump(data)
end

def parse_yaml(data)
  YAML.load(data)
end

require_relative "../lib/yamled/errors"
# module Errors = Yamled::Error
#
# module Errors
# BadInput = 1
# BadOptions = 2
# end
#

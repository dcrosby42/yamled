module Yamled
  module IO
    EmptyData = nil

    class Base
      attr_reader :io
      def initialize(io)
        @io = io
      end

      def close
        @io.close
      end
    end

    class Input < Base
      require 'yaml'
      def get_data
        input = io.read
        if input.strip == ''
          return EmptyData
        else
          YAML.load(input)
        end
      end
    end

    class Output < Base
      require 'yaml'
      def print_data(data)
        if data == IO::EmptyData
          print_empty
        else
          io.print YAML.dump(data)
        end
      end

      def print_value(v)
        str = case v
              when Hash, Array
                YAML.dump(v)
              else
                v.to_s
              end
        io.print str
      end

      def print_empty
        print_value ''
      end
    end

    class Logger < Base
      def initialize(io)
        @io = io
      end
      def log(str)
        io.puts ">> #{str}"
      end
    end

    class << self
      def input_from(in_io)
        Input.new(in_io)
      end

      def output_to(out_io)
        Output.new(out_io)
      end

      def log_to(out_io)
        Logger.new(out_io)
      end
    end
  end
end

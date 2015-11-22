module Yamled
  module ReprintAction
    class << self
      def run(options, input, output, logger)
        data = input.get_data
        # puts "ReprintAction: data=#{data.inspect}"
        output.print_data data
      end
    end
  end

  module ReadAction
    class << self
      def run(options, input, output, logger)
        path = options[:path]
        data = input.get_data
        # puts "ReadAction: data=#{data.inspect}"
        node = data
        if !path.nil?
          steps = path.split("/")
          while steps.count > 0
            step = steps.shift
            node = node[step]
          end
        end
        output.print_value node
      end
    end
  end

  module WriteAction
    class << self
      def run(options, input, output, logger)
        path = options[:path]
        value = options[:value]
        data = input.get_data
        parent = nil
        step = nil
        node = data
        if !path.nil?
          steps = path.split("/")
          while steps.count > 0
            step = steps.shift
            parent = node
            node = node[step]
          end
        end

        if !parent.nil?
          parent[step] = value
        else
          data = value
        end

        output.print_value data
      end
    end
  end

  Actions = {
    reprint: ReprintAction,
    get: ReadAction,
    set: WriteAction
  }
end

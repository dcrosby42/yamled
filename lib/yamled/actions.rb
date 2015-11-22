module Yamled
  module ReprintAction
    class << self
      def run(options, input, output, logger)
        output.print_data input.get_data
      end
    end
  end

  module ReadAction
    class << self
      def run(options, input, output, logger)
        data = input.get_data
        if options[:path].nil?
          output.print_value data
        else
          steps = options[:path].split("/")
          node = data
          while steps.count > 0
            step = steps.shift
            node = node[step]
          end
          output.print_value node
          # output.print_value "??ReadAction path=#{options[:path]} TODO??"
        end
      end
    end
  end

  Actions = {
    reprint: ReprintAction,
    get: ReadAction
  }
end

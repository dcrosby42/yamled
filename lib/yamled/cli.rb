module Yamled
  module CLI
    class << self
      def run(argv:,stdin:,stdout:,stderr:)

        options, input, output, logger = setup_io(
          Options.load(argv),
          stdin,
          stdout,
          stderr)

        action_id = options.delete(:action)
        action = Yamled::Actions[action_id]
        action.run(options, input, output, logger)

        input.close
        output.close
        logger.close
      end

      private 

      def setup_io(options, stdin, stdout, stderr)
        options = options.dup

        infile = options.delete(:infile)
        instream = if infile == :stdin
                     stdin
                   else
                     File.open(infile, "r")
                   end

        outfile = options.delete(:outfile)
        outstream = if outfile == :stdout
                      stdout
                    else
                      File.open(outfile, "wb")
                    end

        logfile = options.delete(:logfile)
        logstream = if logfile == :stderr
                      stderr
                    elsif logfile == :stdout
                      stdout
                    else
                      File.open(logfile, "wb")
                    end

        input = Yamled::IO.input_from(instream)
        output = Yamled::IO.output_to(outstream)
        logger = Yamled::IO.log_to(stderr)

        return [options, input, output, logger]
      end
    end

    module Options
      Defaults = {
        infile: :stdin,
        outfile: :stdout,
        logfile: :stderr,
        action: :reprint,
      }

      class << self
        def load(argv)
          massage(parse_argv(argv))
        end

        def parse_argv(argv)
          argv_dup = argv.dup

          options = Defaults

          require 'optparse'
          parser = OptionParser.new do |opts|
            opts.banner = "Usage: yamled [options]"

            opts.on("-g", "--get [PATH]", String, "Read a value at a path.") do |path|
              options[:action] = :get
              options[:path] = path
            end
          end
          begin
            parser.parse!(argv_dup)
          rescue => e
            puts e.message
            puts parser.help
            exit 2
          end


          return options
        end

        def massage(options)
          options
          # options = options.dup
          # if options[:action] == :get and !options[:path]
          #   options[:action] = :reprint
          # end
          # return options
        end
      end
    end
  end
end

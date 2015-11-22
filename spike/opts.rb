require 'optparse'

options = {}
OptionParser.new do |opts|
  opts.banner = "Usage: example.rb [options]"

  opts.on("-v", "--[no-]verbose", "Run verbosely") do |v|
    puts "hi"
    options[:verbose] ||= 0
    options[:verbose] += 1
  end
end.parse!

p options
p ARGV

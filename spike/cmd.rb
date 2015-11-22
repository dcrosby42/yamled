require 'open3'
o,s = Open3.capture2("cat", stdin_data: "hello\nworld")
p s.exitstatus

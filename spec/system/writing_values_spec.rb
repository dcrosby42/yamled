require 'system/spec_helper'


context "writing values" do
  def run_yamled(input=nil, arg_string=nil)
    r = YamledTestDriver.run(input,arg_string)
    @stdout = r.stdout
    @stderr = r.stderr
    @exit_status = r.exit_status
  end

  def run_yamled_successfully(input=nil,arg_string=nil)
    run_yamled(input,arg_string)
    if @exit_status != 0 or @stderr != ''
      fail("Exited #{@exit_status}.\n<STDOUT:>#{@stdout}\n<STDERR:>#{@stderr}")
    end
  end

  simple_value_cases = [
    "first string read",
    0,
    42,
    37.37,
    0.0,
    true,
    false,
  ]
  
  context "with root path specified" do
    context "simple values" do
      simple_value_cases.each do |data|
        it "print simply as #{data.inspect}" do
          run_yamled_successfully '', "--set-root --value #{data.inspect}"
          expect(@stdout).to eq(data.inspect)
        end
      end
    end

    # context "complex values" do
    #   it "print maps as yaml" do
    #     data = { "nested" => { "hashes" => [ 'and', 'arrays' ] } }
    #     run_yamled_successfully to_yaml(data), '--get'
    #     expect(@stdout).to eq(to_yaml(data))
    #   end
    #   it "print arrays as yaml" do
    #     data = [ {'one'=>1}, {'two'=>2} ]
    #     run_yamled_successfully to_yaml(data), '--get'
    #     expect(@stdout).to eq(to_yaml(data))
    #   end
    # end
  end

  context "with simple map-path specified" do
    let(:data) {{
      "britain" => { "scotland" => { "item" => "_" } }
    }}

    context "simple values" do
      simple_value_cases.each do |c|
        path = "britain/scotland/item"
        it "print value at '#{path}' simply as #{c.inspect}" do
          value = "HI THERE!"
          input = to_yaml(data)
          run_yamled_successfully input, "--set #{path} --value #{c.inspect}"

          # Update the data structur to match output expectations:
          data["britain"]["scotland"]["item"] = c
          expect(@stdout).to eq(to_yaml(data))
        end
      end
    end
  #
  #   context "complex values" do
  #     it "print maps as yaml" do
  #       run_yamled_successfully to_yaml(data), '--get britain'
  #       expect(@stdout).to eq(to_yaml(data['britain']))
  #     end
  #     it "print arrays as yaml" do
  #       items = [ {'one'=>1}, {'two'=>2} ]
  #       data["britain"]["scotland"]["items"] = items
  #       run_yamled_successfully to_yaml(data), '--get britain/scotland/items'
  #       expect(@stdout).to eq(to_yaml(items))
  #     end
  #   end
  end

end

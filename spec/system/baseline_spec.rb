require 'system/spec_helper'


context "running the yamled command" do
  def run_yamled(input=nil)
    r = YamledTestDriver.run(input)
    @stdout = r.stdout
    @stderr = r.stderr
    @exit_status = r.exit_status
  end
  
  it "runs with blank input" do
    run_yamled
    expect(@stderr).to eq("")
    expect(@stdout).to eq("")
    expect(@exit_status).to eq(0)
  end

  it "runs with nil input" do
    run_yamled nil
    expect(@stderr).to eq("")
    expect(@stdout).to eq("")
    expect(@exit_status).to eq(0)
  end

  context "passing through various simple inputs" do
    pass_thru_cases = [
      "a string",
      42,
      123.456,
      [],
      [ 1, 2, "three" ],
      {},
      { "hello" => [ "world" ] },
      [ {"one"=>1, "two"=>2}, {"three"=>3 } ],
    ]
    pass_thru_cases.each do |data|
      it "for case: #{data.inspect}" do
        input = to_yaml(data)
        run_yamled input
        expect(@stderr).to eq("")
        expect(@stdout).to eq(input)
        expect(parse_yaml(@stdout)).to eq(data)
        expect(@exit_status).to eq(0)
      end
    end
  end

  context "pass-thru a real-world example" do 
    it "handles optional formatting (whitespace, optional quotes)" do
      input = read_test_file("hosts.yaml")
      run_yamled input
      expect(@stderr).to eq("")
      # See the data is preserved:
      data = parse_yaml(input)
      expect(parse_yaml(@stdout)).to eq(parse_yaml(input))
      expect(@exit_status).to eq(0)
    end
    it "handles a large canonical file" do
      input = read_test_file("hosts_groomed.yaml")
      run_yamled input
      expect(@exit_status).to eq(0)
      # See the data is preserved:
      data = parse_yaml(input)
      expect(parse_yaml(@stdout)).to eq(parse_yaml(input))
      # Check byte-for-byte output matches input:
      expect(@stdout).to eq(input)
    end

  end

  context "bad input text" do
    it "reports error" do
      run_yamled("---\nthis: \"borked\n")
      expect(@exit_status).to eq(Yamled::Errors::BadInput)
      expect(@stdout).to eq('')
      expect(@stderr).to match("unexpected end of stream")
    end
  end
end


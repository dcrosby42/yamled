require 'system/spec_helper'


context "proper cli usage" do
  def run_yamled(input=nil,args=nil)
    r = YamledTestDriver.run(input,args)
    @stdout = r.stdout
    @stderr = r.stderr
    @exit_status = r.exit_status
  end
  
  context "requesting help" do
    cases = [
      "-h",
      "--help",
    ]
    cases.each do |helpopt| 
      it "responds to #{helpopt}" do
        run_yamled nil, helpopt
        expect(@stdout).to match(/Usage: yamled.*--get/m)
        expect(@stderr).to eq('')
        expect(@exit_status).to eq(0)
      end
    end
  end

  context "bad options" do
    it "exits and shows usage" do
      run_yamled nil, "--badness"
      expect(@stdout).to match(/invalid option.*--badness.*Usage: yamled.*--get/m)
      expect(@stderr).to eq('')
      expect(@exit_status).to eq(Yamled::Errors::BadOptions)
    end

  end

end

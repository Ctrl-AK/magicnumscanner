require './magicnumscanner'

describe MagicNumScanner do
  it "Must initialize a magic num instance" do
    mns=MagicNumScanner.new()
    mns.should be_an_instance_of MagicNumScanner
  end

  it "Must generate a valid report for windows lbraries" do
    mns=MagicNumScanner.new()
    mns.generate_report("EXE (Windows) Desc: Windows|DOS executable file","4D 5A").should == "Found: EXE (Windows) Desc: Windows|DOS executable file | More info: http://filext.com/file-extension/EXE"
  end



  it "Must initialize a magic num instance and run succesully using magicnumscanner.exe" do
    mns=MagicNumScanner.new()
    mns.action!('./magicnumscanner.exe')
  end


end
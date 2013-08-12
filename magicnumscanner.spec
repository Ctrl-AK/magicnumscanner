require './magic_num_scanner_lib'

describe MagicNumScanner do
  it "Must initialize a magic num instance" do
    mns=MagicNumScanner.new()
    mns.should be_an_instance_of MagicNumScanner
  end

  it "Must generate a valid object reported for windows lbraries" do
    mns=MagicNumScanner.new()
    mns.generate_reported_object("EXE (Windows) Desc: Windows|DOS executable file","4D 5A").should == {:filetype=>"EXE (Windows) Desc: Windows|DOS executable file",:ref=>["http://filext.com/file-extension/EXE"],:signature=>"4D 5A"}
  end

  it "Must generate a report from a detected file" do
    mns=MagicNumScanner.new()
    mns.reported_signatures<<mns.generate_reported_object("EXE (Windows) Desc: Windows|DOS executable file","4D 5A")
    mns.generate_html_report
    File.exists?("output.html").should == true
  end

  it "Must initialize a magic num instance and run succesully using magicnumscanner.exe" do
    mns=MagicNumScanner.new()
    mns.action!('./magicnumscanner.exe')
    mns.generate_html_report
  end


end
require "spec_helpers.rb"

describe "When performing a single SNMPv2 SET request" do
  it "should set the value" do
    @snmp_v2.set({"1.9.9.3.1" => "New Value"}).expect do |response|
      response.should have(1).item
      response["1.9.9.3.1"].should == true
    end
  end

  it "should return a SNMP::ResponseError OID is not writable" do
    @snmp_v2.set({"1.9.9.3.3" => "New Value"}).expect do |response|
      response.should have(1).item
      response["1.9.9.3.3"].should be_a(SNMP::ResponseError)
      response["1.9.9.3.3"].error_status.should == :notWritable
    end
  end
end

describe "When performing multiple SNMPv2 SET requests simultaneously" do
  it "should set two values correctly" do
    @snmp_v2.set({"1.9.9.3.1" => "New Value", "1.9.9.3.2" => "New Value"}).expect do |response|
      response.should have(2).items
      response["1.9.9.3.1"].should == true
      response["1.9.9.3.2"].should == true
    end
  end

  it "should set one value correctly if the other is not writable" do
    @snmp_v2.set({"1.9.9.3.1" => "New Value", "1.9.9.3.3" => "New Value"}).expect do |response|
      response.should have(2).items
      response["1.9.9.3.1"].should == true
      response["1.9.9.3.3"].should be_a(SNMP::ResponseError)
      response["1.9.9.3.3"].error_status.should == :notWritable
    end
  end
end
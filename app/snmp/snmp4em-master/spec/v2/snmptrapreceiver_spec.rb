require "spec_helpers.rb"

describe "When receiving an SNMPv1 trap" do
  it "should receive the trap" do
    manager = SNMP4EM::NotificationManager.new(:port => 1621)

    manager.on_trap do |trap|
      trap.should be_a(SNMP::SNMPv2_Trap)
      trap.trap_oid.to_s.should == "1.2.3"

      EM.stop
    end

    `snmptrap -v 2c -c public --noPersistentLoad=yes localhost:1621 '' 1.2.3`
  end
end
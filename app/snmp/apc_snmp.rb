require 'snmp'

unless ARGV[0]
        puts "Please supply an APC hostname/ip"
        exit
end

APC_Data = Array.new

SNMP::Manager.open(:Host => ARGV[0], :Version => :SNMPv1, :Community => 'public') do |manager|
        manager.load_module("PowerNet-MIB")
        response = manager.get(["upsBasicIdentModel.0",
                                "upsAdvIdentSerialNumber.0",
                                "upsAdvBatteryCapacity.0",
                                "upsAdvBatteryTemperature.0",
                                "upsBasicOutputStatus.0",
                                "sysContact.0",
                                "sysUpTime.0"])

        response.each_varbind do |varbind|
                 APC_Data.push(varbind.value.to_s)
        end
end

if APC_Data[4] == 1 then
        status = "unknown"
elsif APC_Data[4] == "2" then
        status = "online"
elsif APC_Data[4] == 3 then
        status = "onBattery"
elsif APC_Data[4] == 6 then
        status = "ByPass"
elsif APC_Data[4] == 7 then
        status = "off"
elsif APC_Data[4] == 8 then
        status = "rebooting"
elsif APC_Data[4] == 9 then
        status = "switchedBypass"
else
        status = "Shit..."
end


puts "APC #{APC_Data[0]}           #{APC_Data[1]}"
puts ""
puts "Battery Capacity:  #{APC_Data[2]}%"
puts "Battery Temp:  #{APC_Data[3]}c"
puts "Output Status: #{status}"

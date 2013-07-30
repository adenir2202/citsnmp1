require 'snmp'

ifTable_columns = ["ifIndex", "ifDescr", "ifInOctets", "ifOutOctets"]
SNMP::Manager.open(:host => 'localhost') do |manager|
    manager.walk(ifTable_columns) do |row|
        row.each { |v| print "\t#{v.value}" }
        puts
    end
end

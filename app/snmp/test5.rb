require 'snmp'
include SNMP

ifDescr_OID = ObjectId.new("1.3.6.1.2.1.2.2.1.2")
ifAdminStatus_OID = ObjectId.new("1.3.6.1.2.1.2.2.1.7")
MAX_ROWS = 10
Manager.open(:host => 'localhost') do |manager|
    response = manager.get_bulk(0, MAX_ROWS, [ifDescr_OID, ifAdminStatus_OID])
    list = response.varbind_list
    until list.empty?
        ifDescr = list.shift
        ifAdminStatus = list.shift
        puts "#{ifDescr.value}    #{ifAdminStatus.value}"
    end
end


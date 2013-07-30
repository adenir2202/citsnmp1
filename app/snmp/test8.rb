require 'snmp'
include SNMP
 
host = ARGV[0] || 'localhost'
 
manager = Manager.new(:Host => host, :Community => 'com', :Port => 161)
ifTable = ObjectId.new("1.3.6.1.4.1.140.625.190.1.55")
next_oid = ifTable
while next_oid.subtree_of?(ifTable)
    response = manager.get_next(next_oid)
    varbind = response.varbind_list.first
    next_oid = varbind.name
    puts "#{varbind.value.to_s}"
end

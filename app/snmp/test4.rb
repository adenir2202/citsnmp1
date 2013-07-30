#!/usr/bin/env ruby
require 'snmp'
include SNMP

Manager.open(:host => "10.2.1.188") do |manager|
  #  ifTable = ObjectId.new("1.3.6.1.4.1.9.9.46.1.3.1.1.2")
    ifTable = ObjectId.new("1.3.6.1.4") 	
    next_oid = ifTable
    while next_oid.subtree_of?(ifTable)
        response = manager.get_next(next_oid)
        varbind = response.varbind_list.first
        next_oid = varbind.name
	v2s = varbind.to_s
	if v2s =~ /^.*value=-1.*$/
	else 
        	puts v2s
	end
    end
end

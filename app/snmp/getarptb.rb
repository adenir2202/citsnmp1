require 'rubygems'
require 'snmp'
include SNMP

class OctetString
    def to_hex
        h=""
        each_byte{ |b| h << "%02x" % b }
        h
    end # def to_hex
end # class OctetString

Manager.open(:Host => '10.0.1.81') do |manager|
      arpTable = ObjectId.new("1.3.6.1.2.1.4.22.1.2")
         next_oid = arpTable
         while next_oid.subtree_of?(arpTable) do
             response = manager.get_next(next_oid)
             varbind = response.varbind_list.first
             next_oid = varbind.name
       	     value = varbind.value
             case value
                when OctetString
                   value = value.to_hex
             end
             puts "#{varbind.name.to_s}  #{value}"

         end
   end

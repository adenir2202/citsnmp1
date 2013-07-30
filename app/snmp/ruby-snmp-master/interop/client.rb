require 'snmp'
require 'drb'

include SNMP

def compare_gets(oid)
  puts "OID--->: #{oid}"
#  system("snmpget -v2c -c public localhost:161 #{oid}") || fail("snmpget failed")
  system("snmpget -v2c -c public localhost:1061 #{oid}") || fail("snmpget failed")
  message1 = @server.last_pdu
  request_id = @server.last_request_id

  puts "OID-->: #{oid} [#{message1}]"
  Manager.open(:host => 'localhost', :port => 161) do |manager|
    manager.next_request_id = request_id
    puts manager.get(oid).varbind_list.first
  end
  message2 = @server.last_pdu
  puts "OID-->: #{oid} 111->#{message1}<-111 222->#{message2}<-222"

 # fail unless message1==message2
end

DRb.start_service
@server = DRbObject.new(nil, "druby://localhost:8082")

OID_LIST = ["1.3.6.1.2.1.2.1.0", "1.3.6.1.2.1.1.1.0", "1.3.6.1.2.1.1.2.0",
            "1.3.6.1.2.1.4.20.1.255.255.255.255", "1.3.6.1.2.1.11.1.0",
            "1.3.6.1.2.1.1.3.0", "1.3.6.1.2.1.31.1.1.1.6.1", "1.3.6.1.2.1.2.2.1.5.1"]
OID_LIST.each { |oid| compare_gets(oid) }

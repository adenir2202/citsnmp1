#!/usr/bin/env ruby
require 'snmp'
require 'logger'

include SNMP

class OIDDiscovery
  MAX_ROWS = 10

  def self.getOid(host)
    SNMP::Manager.open(:host => host) do |manager|
        response = manager.get(["sysDescr.0", "sysName.0"])
        response.each_varbind do |vb|
            puts "#{vb.name.to_s}  #{vb.value.to_s}  #{vb.value.asn1_type}"
        end
    end
  end
    
  def self.setOid()
    gerente = Manager.new(:host => @host)
    varbind = VarBind.new("1.3.6.1.2.1.1.5.0", OctetString.new("My System Name"))
    gerente.set(varbind)
    gerente.close
  end
    
    
  def self.walkOid()
    ifTable_columns = ["ifIndex", "ifDescr", "ifInOctets", "ifOutOctets"]
    SNMP::Manager.open(:host => @host) do |manager|
        manager.walk(ifTable_columns) do |row|
            row.each { |v| print "\t#{v.value}" }
            puts
        end
    end
  end
    
  def self.nextOid()
    Manager.open(:host => @host) do |manager|
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
  end
    
    
  def self.bulkOid()
    ifDescr_OID = ObjectId.new("1.3.6.1.2.1.2.2.1.2")
    ifAdminStatus_OID = ObjectId.new("1.3.6.1.2.1.2.2.1.7")
    Manager.open(:host => @host) do |manager|
        response = manager.get_bulk(0, MAX_ROWS, [ifDescr_OID, ifAdminStatus_OID])
        list = response.varbind_list
        until list.empty?
            ifDescr = list.shift
            ifAdminStatus = list.shift
            puts "#{ifDescr.value}    #{ifAdminStatus.value}"
        end
    end
  end
    
    
  def self.trapOid()
    log = Logger.new(STDOUT)
    m = SNMP::TrapListener.new do |manager|
        manager.on_trap_default do |trap|
            log.info trap.inspect
        end
    end
    m.join
  end
    
     
  def self.waldTreeOid()
    manager = Manager.new(:Host => @host, :Community => 'com', :Port => 161)
    ifTable = ObjectId.new("1.3.6.1.4.1.140.625.190.1.55")
    next_oid = ifTable
    while next_oid.subtree_of?(ifTable)
        response = manager.get_next(next_oid)
        varbind = response.varbind_list.first
        next_oid = varbind.name
        puts "#{varbind.value.to_s}"
    end
  end
end

@host = ARGV[0] || 'localhost'
OIDDiscovery.getOid()
OIDDiscovery.walkOid()
OIDDiscovery.nextOid


require 'ipscanner'
require 'socket'

class HostDiscovery
  # routines to convert between dotted strings <-> integer IPs

  def self.ip_to_int(ipstring)
    v = 0
    ipstring.split(".").reverse.each do |s|
      v = (v << 8) + (s.to_i)
    end
    return v
  end

  def self.int_to_ip(v)
    array = []
    n = 4
    begin
      array << (v % 0x100).to_s
      v >>= 8
    end while((n -= 1) > 0)
    return array.join(".")
  end

# routine to convert string characters to int array
# used in SSID encoding

  def self.string_to_int_array(s)
    return "[" + s.unpack("c*").join(",") + "]"
  end

# override scan method
    def self.scanWsockt(ip_base = '10.2.1.', range = 1..254, t = 50)
        computers = [] 
        threads = []  
        Socket.do_not_reverse_lookup = false    
        (range).map {  |i| 
            threads << Thread.new {
                ip = ip_base + i.to_s
                if IPScanner.pingecho(ip, t) 
                    computers << Socket.getaddrinfo(ip, nil)[0][2]                    
                end
            }
        }.join      
        # wait for all threads to terminate
        threads.each { |thread| thread.join }
        return computers
    end
    
#---------------------------------- Returns all computers in network
# saida do comando arp -a
#(10.2.1.2) em 00:0c:29:16:b3:27 [ether] em p4p1
    def self.scanWarp(command)
      computers = [] 
      lines = IO.popen(command)
      lines.each do |sys|
        if sys.count(' ') == 6
          m = sys.split
          computers << "#{m[1].sub(/\((.*)\)/,'\1')} #{m[3]} #{m[6]}"
        end
      end
      return computers
    end

#---------------------------------- Returns all computers in network
#------- Saida do comando nmpa: Nmap scan report for 10.2.1.199
#                               Host is up (0.00043s latency).   
    def self.scanWnmap(command)
      computers = [] 
      lines = IO.popen(command)

      lines.each do |sys|
        if sys =~ /^Nmap scan/
          m = sys.split
          computers << "#{m[4]}"
        end
      end
      
      return computers
    end
   

#----------------------------------- Returns my ip
    def self.myIp()
      computer = ""
      addr = UDPSocket.open {|s| 
        s.connect("255.255.255.0", 1); 
        computer = s.addr.last}
      return computer
    end
  
  
    def self.getMibAllHost()
      hosts = []
      hosts = HostDiscovery.scanWarp('arp -a')
      hosts.each do |ip|
        puts OIDDiscovery.getOid(ip)
      end
    end
end

#puts "Meu ip: #{HostDiscovery.myIp()} #{HostDiscovery.ip_to_int(HostDiscovery.myIp())}"

#puts "scanning com nmap - comando nmap -n -sP -T4 #{HostDiscovery.myIp()}/24"
#puts HostDiscovery.scanWnmap("nmap -n -sP -T4 #{HostDiscovery.myIp()}/24")

#puts 'scanning com arp - comando arp -a'
#puts "#{HostDiscovery.scanWarp('arp -a')}"

#puts 'scanning com sockt - comando IPScanner.pingecho and thread'
#puts "#{HostDiscovery.scanWsockt}"

HostDiscovery.getMibAllHost()

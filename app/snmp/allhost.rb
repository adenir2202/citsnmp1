    require 'socket'
    require 'ipaddr'
#METHOD 1
    ip = IPSocket.getaddress(Socket.gethostname)
    puts "em 1 #{ip}" 

#METHOD 2
    host = Socket.gethostname
    puts "em 2 #{host}" 

#METHOD 3(uses Google's address)
    ip = UDPSocket.open {|s| s.connect("64.233.187.99", 1); s.addr.last}
    puts "em 3 #{ip}" 

#METHOD 4(uses gateway address)
    def local_ip
      orig, Socket.do_not_reverse_lookup = Socket.do_not_reverse_lookup, true  # turn off reverse DNS resolution temporarily

      UDPSocket.open do |s|
        s.connect '10.2.1.1', 1
        s.addr.last
      end
    ensure
      Socket.do_not_reverse_lookup = orig
    end

    ip=local_ip
    puts "em 4 #{ip}" 


# nmap -sP 10.2.1.*
   puts "***#{Socket::getaddrinfo(Socket.gethostname,"echo",Socket::AF_INET)[0][3]}"
   puts "... #{UDPSocket.open {|s| s.connect "10.2.1.1", 80; s.addr }}"

   ipaddr = "10.2.1.188"
 #  internal.find { |i| i.include?(ipaddr) }


net1 = IPAddr.new("192.168.2.0/24")
net2 = IPAddr.new("192.168.2.100")
net3 = IPAddr.new("192.168.3.0")
p net1.include?(net2)     #=> true
p net1.include?(net3)     #=> false

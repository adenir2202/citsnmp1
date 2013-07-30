require 'socket'
MULTICAST_ADDR = "10.2.1.188" 
PORT= 5000
begin
  socket = UDPSocket.open
  socket.setsockopt(Socket::IPPROTO_IP, Socket::IP_TTL, [1].pack('i'))
  socket.send(ARGV.join(' '), 0, MULTICAST_ADDR, PORT)
ensure
  socket.close 
end

require 'socket'
iface = "p4p1"
sock = Socket.new(Socket::AF_INET, Socket::SOCK_DGRAM,0)
    buf = [iface,""].pack('a16h16')
    sock.ioctl(SIOCGIFADDR, buf);
    sock.close
    # Another way
    # Socket::unpack_sockaddr_in(buf[16..256])[1]
    buf[20..24].to_ipaddr4

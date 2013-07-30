require 'resolv'

Resolv.each_address("www.centralit.com.br") do |ip|
  puts ip
end

#!/usr/bin/env ruby
require 'snmp'
require 'optparse'
include SNMP

options = {}

optparse = OptionParser.new do |opts|
	opts.banner = "Usage: check_hdfs.rb [options]"
 	opts.on("-u", "--url URL", "URL of dfs health page") do |url|
 		options[:url] = url
 	end
	opts.on("-o", "--oid OID", "Informe OID snmp") do |oid|
		options[:oid] = oid
	end
	opts.on("-c", "--criticaldfs CRITICALDFS", "Critical Limit for DFS free space") do |criticaldfs|
		options[:criticaldfs] = criticaldfs
	end
	opts.on("-x", "--warningunreplicatedblocks WARNINGUNREPLICATEDBLOCKS", "Warning limit for UnReplicated Blocks") do |warningunreplicatedblocks|
		options[:warningunreplicatedblocks] = warningunreplicatedblocks
	end
	opts.on("-z", "--criticalunreplicatedblocks CRITICALUNREPLICATEDBLOCKS", "Critical limit for UnReplicated Blocks") do |criticalunreplicatedblocks|
		options[:criticalunreplicatedblocks] = criticalunreplicatedblocks
	end
	opts.on("-H", "--help", "Display this screen") do
    puts opts
    exit
  end
end

optparse.parse!
puts options
if options.size <= 0 
   puts "enter -H or --help to display usage options"
   exit
end

url = options[:url]
oid = options[:oid]
criticaldfs = options[:criticaldfs]
warningunreplicatedblocks = options[:warningunreplicatedblocks]
criticalunreplicatedblocks = options[:criticalunreplicatedblocks]

if url == nil
   puts "Url em branco"
   exit
end
puts oid
Manager.open(:host => "#{url}") do |manager|
    ifTable = ObjectId.new("#{oid}")            #1.3.6.1.2.1.2.2")
    next_oid = ifTable
    while next_oid.subtree_of?(ifTable)
        response = manager.get_next(next_oid)
        varbind = response.varbind_list.first
        next_oid = varbind.name
        puts varbind.to_s
    end
end

#!/usr/bin/env ruby
#
# https://www.codewars.com/kata/515decfd9dcfc23bb6000006
# 2p

ip = ARGV.first
abort 'You need to provide ip address' unless ip

# Using regex
def validate_ip_regex(ip_addr)
  ip_addr =~ /
    ^(([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])\.){3}
    ([0-9]|[1-9][0-9]|1[0-9][0-9]|2[0-4][0-9]|25[0-5])$
  /x
end

# Using ruby
def validate_ip(ip_addr)
  blocks = ip_addr.split('.')
  return false if blocks.size != 4

  blocks.all? { |block| validate_block(block) }
end

def validate_block(block)
  number = Integer(block)
  number.to_s == block && number.between?(0, 255)
rescue StandardError
  false
end

# if validate_ip_regex(ip)
if validate_ip(ip)
  puts 'Valid ip address'
else
  puts 'Invalid ip address'
end

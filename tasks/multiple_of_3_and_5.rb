#!/usr/bin/env ruby
#
# https://www.codewars.com/kata/514b92a657cdc65150000006
# 1p

abort 'You need to provide a number >= 0' if ARGV.empty?

begin
  number = Integer(ARGV[0])
rescue ArgumentError => e
  abort "Error: #{e.message}"
end

def multiple(num)
  (3...num).select { |n| (n % 3).zero? || (n % 5).zero? }.reduce(:+) || 0
end

puts "Sum of numbers multiplied by 3 or 5 is #{multiple(number)}"

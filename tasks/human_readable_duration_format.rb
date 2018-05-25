#!/usr/bin/env ruby
#
# https://www.codewars.com/kata/52742f58faf5485cae000b9a
# 2p

abort 'You need to provide a number >= 0' if ARGV.empty?

begin
  number = Integer(ARGV[0])
rescue ArgumentError => e
  abort "Error: #{e.message}"
end

MAPPING = {
  year: 60 * 60 * 24 * 365,
  day: 60 * 60 * 24,
  hour: 60 * 60,
  minute: 60,
  second: 1
}.sort { |x, y| y[1] <=> x[1] }.to_h

def format_duration(seconds)
  return 'now' if seconds <= 0

  seconds_left = seconds
  formats = []

  MAPPING.each do |k, v|
    unit = seconds_left / v
    next if unit.zero?

    type = unit > 1 ? "#{k}s" : k
    formats.push("#{unit} #{type}")
    seconds_left %= v
  end

  [formats[0..-2].join(', '), formats.last].reject(&:empty?).join(' and ')
end

puts format_duration(number)

#!/usr/bin/env ruby

while (line = gets)
  result = line.gsub(/[0-9]/, '*')
  puts result
end

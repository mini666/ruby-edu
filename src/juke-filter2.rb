#!/usr/bin/env ruby

def substude(str)
  if str.to_i.odd?
    '*' * str.length
  else
    '#' * str.length
  end
end

while (line = gets)
  loop do
    match_data = line.match(/[0-9]+/)
    break unless match_data
    result = substude(match_data[0])
    line = line.sub(match_data[0], result)
  end

  puts line
end

#!/usr/bin/env ruby

while (line = gets)
  result = line.gsub(/([0-9]+)/) do |s|
    if s.to_i.odd?
      '*' * s.length
    else
      '#' * s.length
    end
  end

  puts result
end

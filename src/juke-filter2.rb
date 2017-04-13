#!/usr/bin/env ruby

while (line = gets)
  result = line.gsub(/([0-9]+)/) do |s|
    if $1.to_i.odd?
      '*' * $1.length
    else
      '#' * $1.length
    end
  end

  puts result
end

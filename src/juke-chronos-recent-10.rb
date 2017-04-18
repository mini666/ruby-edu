#!/usr/bin/env ruby

require 'open-uri'
require 'json'

chronos_url = 'http://xxx.xxx.xxx/xxx/xxx'
json = JSON.parse(open(chronos_url).read, symbolize_names: true)
sorted_items = json.sort do |a, b|
  a_time = a[:lastSuccess].empty? ? Time.at(0) : Time.parse(a[:lastSuccess])
  b_time = b[:lastSuccess].empty? ? Time.at(0) : Time.parse(b[:lastSuccess])
  b_time <=> a_time
end

top_10 = sorted_items.take(10)

top_10.each do |item|
  puts item[:name] + ": " + item[:lastSuccess]
end

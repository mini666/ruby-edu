#!/usr/bin/env ruby

require 'open-uri'
require 'json'

chronos_url = 'http://xxx.xxx.xxx/xxx/xxx'
json = JSON.parse(open(chronos_url).read, symbolize_names: true)
sorted_items = json.sort_by do |item|
  lastSuccessTime = item[:lastSuccess]
  (lastSuccessTime.empty? ? Time.at(0).to_i : Time.parse(lastSuccessTime).to_i) * -1
end

top_10 = sorted_items.take(10)

top_10.each do |item|
  puts item[:name] + ": " + item[:lastSuccess]
end

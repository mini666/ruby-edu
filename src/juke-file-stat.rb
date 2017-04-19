#!/usr/bin/env ruby

files = ARGV.flat_map do |path|
  if Dir.exist?(path)
    Dir["#{path}/*"]
  elsif File.exist?(path)
    path
  else
    nil 
  end 
end.compact

ext_groups = files.group_by { |file| File.extname(file) }
file_stats = ext_groups.map do |ext, items|
  [ext, items.map { |file| File.size(file) }]
end

file_stats.to_h.sort.each do |ext, sizes|
  printf("[%s]\n-count: %d\n-sum(size): %d\n-max(size): %d\n-min(size): %d\n-avg(size): %f\n\n",
         ext, sizes.count, sizes.sum, sizes.max, sizes.min, sizes.sum / (sizes.count * 1.0))
end

#!/usr/bin/env ruby

files = []
ARGV.each do |path|
  if Dir.exist?(path)
    files += Dir["#{path}/*"]
  elsif File.exist?(path)
    files << path
  else
    puts "#{path} is not directory or file."
  end
end

ext_groups = files.group_by { |file| File.extname(file) }
file_stats = ext_groups.map do |entry|
  [entry[0], entry[1].map { |file| File.size(file) }]
end

file_stats.to_h.sort.each do |entry|
  printf("[%s]\n-count: %d\n-sum(size): %d\n-max(size): %d\n-min(size): %d\n-avg(size): %f\n\n",
         entry[0], entry[1].count, entry[1].sum, entry[1].max, entry[1].min, entry[1].sum / (entry[1].count * 1.0))
end

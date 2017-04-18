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

def collect_file_stat(file_stat, file)
  file_stat[:count] += 1
  file_size = File.size(file)
  file_stat[:sum] += file_size
  file_stat[:max] = file_stat[:max] < file_size ? file_size : file_stat[:max]
  file_stat[:min] = file_stat[:min].zero? ? file_size : file_stat[:min] > file_size ? file_size : file_stat[:min]
  file_stat[:avg] = file_stat[:sum] / (file_stat[:count] * 1.0)
  file_stat
end

ext_groups = files.group_by { |file| File.extname(file) }
file_stats = ext_groups.map do |entry|
  init_obj = { count: 0, sum: 0, max: 0, min: 0, avg: 0 }
  [entry[0], entry[1].reduce(init_obj) do |file_stat, file|
    collect_file_stat(file_stat, file)
  end]
end

file_stats.to_h.sort.each do |entry|
  printf("[%s]\n", entry[0])
  printf("-count: %d\n", entry[1][:count])
  printf("-sum(size): %d\n", entry[1][:sum])
  printf("-max(size): %d\n", entry[1][:max])
  printf("-min(size): %d\n", entry[1][:min])
  printf("-avg(size): %f\n", entry[1][:avg])
  printf("\n")
end

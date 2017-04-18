#!/usr/bin/env ruby

def analyze_detail(file, table_name, block_count)
  found_lines = 0
  while (line = file.gets)
    next unless line.match?(/^\d+\. BP/)
    tokens = line.split
    block_ids = tokens[1].split(':')[1].split('_')
    block_name = block_ids[0] + '_' + block_ids[1]
    block_size = tokens[2].split('=')[1]
    block_status = tokens[3].start_with?('MISSING') ? 'MISSING' : ''
    printf("%s %s %s %s\n", block_name, table_name, block_size, block_status)
    break if (found_lines += 1) == block_count
  end
end

ARGV.each do |target_file|
  File.open(target_file) do |file|
    while (line = file.gets)
      next unless line.start_with?('/hbase/data/default/')
      tokens = line.split
      headers = tokens[0].split('/')
      next unless headers.length == 8
      table_name = headers[4]
      block_count = tokens[3].to_i
      analyze_detail(file, table_name, block_count)
    end
  end
end

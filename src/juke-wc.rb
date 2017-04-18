#!/usr/bin/env ruby

# manage word information
class WordInfo
  attr_accessor :word, :line, :byte_size, :file_name

  def initialize(file_name)
    @word = 0
    @line = 0
    @byte_size = 0
    @file_name = file_name
  end

  def +(other)
    @word += other.word
    @line += other.line
    @byte_size += other.byte_size
    self
  end

  def to_s
    "#{@word}\t#{@line}\t#{@byte_size}\t#{@file_name if @file_name}"
  end
end

def analyze_line(word_info, line)
  word_info.line += 1
  word_info.word += line.split.length
  word_info.byte_size += line.bytesize
end

if ARGV.empty?
  word_infos = [WordInfo.new(nil)]
  while (line = gets)
    analyze_line(word_infos[0], line)
  end
else
  word_infos = Array.new(ARGV.length)
  ARGV.each.with_index do |file_name, idx|
    word_infos[idx] = WordInfo.new(file_name)
    File.read(file_name).lines.each do |l|
      analyze_line(word_infos[idx], l)
    end
  end
end

# print result
word_infos.each do |word_info|
  # puts word_info	# <= simple output
  # formatting output
  printf("%5s\t%5s\t%5s\t%s\n",
         word_info.word, word_info.line,
         word_info.byte_size, word_info.file_name)
end

# print total if exist
# puts word_infos.reduce(WordInfo.new('total'), :+) if word_infos.length > 1
# formatting output
if word_infos.length > 1
  total = WordInfo.new('total')
  word_infos.reduce(total, :+)
  printf("%5s\t%5s\t%5s\t%s\n",
         total.word, total.line,
         total.byte_size, total.file_name)
end

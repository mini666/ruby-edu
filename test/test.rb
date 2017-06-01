#!/usr/bin/env ruby

Dir.glob(File.expand_path('../test_*.rb', __FILE__)).each do |file|
  require file
end

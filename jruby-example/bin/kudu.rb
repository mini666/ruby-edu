#!/usr/bin/env jruby
# frozen_string_literal: true

require 'bundler/setup'
require 'jbundler'

# Using Kudu client
# =================
java_import org.apache.kudu.client.KuduClient::KuduClientBuilder

MASTERS = %w[bmt-hadoop-nn3.dakao.io
             bmt-hadoop-nn4.dakao.io
             bmt-hadoop-rm2.dakao.io].freeze

TABLE_NAME = 'dummy'

client = KuduClientBuilder.new(MASTERS).build

if client.table_exists?(TABLE_NAME)
  table = client.open_table(TABLE_NAME)
  begin
    scanner = client.new_scanner_builder(table).build
    puts scanner.next_rows.take(10).map(&:row_to_string)
  ensure
    scanner.close
  end
end

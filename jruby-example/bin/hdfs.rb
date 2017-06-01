#!/usr/bin/env jruby
# frozen_string_literal: true

require 'bundler/setup'
require 'jbundler'

raise 'principal and keytab required' if ARGV.length != 2
princ, keytab = ARGV
realm = princ.split('@').last

# Using HDFS client
# =================

java_import org.apache.hadoop.conf.Configuration
java_import org.apache.hadoop.security.UserGroupInformation
java_import org.apache.hadoop.fs.FileSystem
java_import org.apache.hadoop.fs.Path
java_import java.lang.System

# 아래 문단은 /etc/krb5.conf 의 default realm 을 사용할 경우에는 실행하지
# 않아도 되는 부분이다
System.setProperty('java.security.krb5.conf', '/etc/krb5.conf')
Krb5Config = Java.sun.security.krb5.Config
kdc_list = Krb5Config.get_instance.get_kdc_list(realm)
System.setProperty('java.security.krb5.realm', realm)
System.setProperty('java.security.krb5.kdc', kdc_list)
Krb5Config.refresh

# Keytab 파일을 이용해 로그인한다
conf = Configuration.new
UserGroupInformation.set_configuration(conf)
UserGroupInformation.login_user_from_keytab(princ, keytab)
puts UserGroupInformation.get_current_user.to_s

fs = FileSystem.get(java.net.URI.new('hdfs://doopey'), conf)
iter = fs.list_files(Path.new('.'), true)

# iter.has_next? 와 iter.next 를 이용해 하나씩 볼 수도 있으나
# Enumerable 하게 만들어서 볼 수도 있다.
module HDFSFileIterator
  include Enumerable
  def each
    return enum_for(:each) unless block_given?
    yield self.next while has_next?
  end
end

enum = iter.extend(HDFSFileIterator)
enum.take(10).each do |file|
  p [file.path.to_s,
     file.len,
     file.group,
     file.owner,
     Time.at(file.modification_time * 0.001)]
end

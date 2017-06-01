jruby-example
=============

```sh
# 디펜던시 설치
jruby -S jbundle install --verbose

# Kudu 클라이언트 예제 실행
jruby -S bin/kudu.rb

# Hadoop 클라이언트 예제 실행 시에는 접근하고자 하는 클러스터의 설정 파일들을
# CLASSPATH 로 지정 후
export CLASSPATH=doopey-conf/

# Principal 과 keytab 파일을 지정해 실행
jruby -S bin/client.rb jg-choi@KAKAO.HADOOP ~/keytabs/jg-choi@KAKAO.HADOOP.keytab
```

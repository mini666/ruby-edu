JRuby
=====

설치
----

```sh
brew install jruby
jgem install bundler jbundler
```

실행 방법
---------

기본적으로 jruby, jgem, jirb 의 실행 파일들이 설치되어 일반 Ruby 와 구분해서
사용할 수 있다.

```sh
jgem install pry
```

Gem 으로 설치한 실행 파일들은 공통적으로 `/usr/local/bin` 에 위치하게 되는데
`#!/usr/bin/env ruby` 으로 시작하므로 단순히 실행할 경우 일반 Ruby 로 실행되는
문제가 있다. 이를 피하기 위해 `jruby -S` 옵션으로 실행한다.

```sh
$ jruby --help | grep '\-S'
  -S                look for the script in bin or using PATH environment variable

$ jruby -S pry
[1] pry(main)> RUBY_VERSION
=> "2.3.1"
[2] pry(main)> RUBY_PLATFORM
=> "java"
```

JBundler
--------

Gemfile 을 이용하는 Bundler 는 일반 Ruby 와 동일하게 동작하지만, Java
라이브러리를 사용하기 위해서는 Rubygems 가 아니라 Maven central 을 보아야
할 것이다. 이를 가능하게 해 주는 것이 JBundler 프로젝트이다.

다음과 같은 내용의 `Jarfile` 을 만들고

```
jar 'org.apache.kudu:kudu-client', '1.3.1'
```

`jruby -S jbundle install --verbose` 을 실행한다. 이제 코드에서 `require
'jbundler'` 를 실행하면 설치된 라이브러리를 사용할 수 있다.

### 예제

Kudu Java 클라이언트를 이용해 Kudu 테이블을 스캔하는 예제이다.

```ruby
#!/usr/bin/env jruby
# frozen_string_literal: true

require 'jbundler'

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
    puts scanner.next_rows.map(&:row_to_string)
  ensure
    scanner.close
  end
end
```

- Java 메소드에 대한 Ruby 스타일 alias 가 제공되는 것을 볼 수 있다.
  `scanner.nextRows` 대신 `scanner.next_rows` 로 적을 수 있는데, 전자도 여전히
  유효하다.
- Pry 를 이용해 interactive 하게 코드를 작성해 나갈 것을 추천. Pry 의 `ls`
  커맨드를 이용해 클래스 계층도에 따른 메소드 목록을 볼 수 있다.
- Ruby 코드는 Java 코드보다 작성하기 쉬울 수 있으나, IDE 의 도움을 받을
  수 있는 부분이 제한적이므로 Java 코드의 사용 비율이 높다면 오히려 생산성이
  더 낮을 수도 있다.

Warbler
-------

Warbler 프로젝트를 이용해 JRuby 프로젝트를 JAR 로 패키징할 수 있다. Java
classloader 관련한 이슈가 있을 수 있는데 해결책들이 없는 것은 아니나
간단하지 않으므로 정상적으로 실행되지 않을 때는 과감히 포기.

```sh
jgem install warbler
```

Executable JAR 를 만들기 위해서는 프로젝트에 `bin` 디렉토리를 만들고 그 안에
실행될 스크립트를 위치시켜야한다.

```sh
$ jruby -S warble

No executable matching config.jar_name found, using bin/kudu.rb
rm -f jruby-example.jar
Creating jruby-example.jar

$ java -jar jruby-example.jar
```

[jruby-example](jruby-example) 예제를 참고.

References
----------

- https://github.com/mkristian/jbundler
- https://github.com/jruby/warbler
- https://github.com/jruby/jruby/wiki/CallingJavaFromJRuby


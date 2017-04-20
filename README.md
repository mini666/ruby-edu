From jg in KAKAO
Ruby crash course for hadoopeng
===============================

Ruby?
-----

Dynamic, object-oriented language.

설치하기
--------

```sh
$ brew update

$ brew reinstall ruby --with-doc

$ ruby --version
ruby 2.4.1p111 (2017-03-22 revision 58053) [x86_64-darwin15]
```

연습하기
--------

### Interactive Ruby

간단히 코드를 테스트 할 때는 IRB 프롬프트 상에서 확인할 수 있다.

```
$ irb
irb(main):001:0> 1 + 2
=> 3
irb(main):002:0> puts 'hello'
hello
=> nil
irb(main):003:0> exit
```

이대로 사용해도 되지만, IRB 의 부족한 부분을 개선한 Pry 라는 대체제가 있으니
이를 사용하도록 하자. 자동완성이 기본적으로 지원되고, 출력 포맷이 개선되었으며
여러가지 유용한 기능들이 추가되어 있다. pry-byebug 를 설치할 경우 디버거
기능도 수행할 수 있다.

```sh
gem install pry pry-doc pry-byebug
```

- 메소드 자동완성
    - `"hello".<TAB>`
- 메소드 목록 출력
    - `ls "hello"`
- 문서 보기
    - `? "hello".reverse`
    - `? "hello".gsub`
- `?` 의 경우 동적으로 소스 근처의 커멘트를 찾아내는 방식이라 정상적으로
  동작하지 않을 수 있다 (e.g. `? Array`) :crying_cat_face:
    - 이러한 경우 정적으로 빌드된 문서를 보는 `ri` 커맨드를 이용한다: `ri Array`.
    - `ri` 는 커맨드 라인에서도 실행 가능한 별도의 툴이다.
- `edit`: 임시로 에디터를 띄워서 편집할 수도 있다
- 디버깅 기능
    - step, next, up, down, backtrace, ...

### 단일 스크립트

간단한 스크립트를 만들 때는 프로젝트 구조에 대해 신경 쓸 필요 없이 `.rb` 파일을
하나 만들어 실행하면 된다. 확장자를 반드시 `rb` 로 맞출 필요는 없다, `sh` 이나
`pl` 과 마찬가지로 컨벤션일 뿐. 아래와 같은 파일을 만들고,

```ruby
#!/usr/bin/env ruby

puts 'hello world'
```

`ruby hello.rb` 와 같이 실행하거나 `chmod +x` 후 `./hello.rb` 로 실행한다.

기본 문법
---------

```ruby
# Shell script 와 마찬가지로 # 로 커멘트를 시작한다.

# 변수 할당
a = 1

# 여러개를 한번에
b, c = 2, "hello"

# 메소드 호출
puts(a)

# 괄호는 optional 하다
puts a

# 조건문
if a == 0
  puts 'a is zero'
elsif a == 1
  puts 'a is one'
else
  puts 'a is something else'
end

# 조건 표현은 true/false 뿐 아니라 모든 오브젝트가 허용된다.
# false 와 nil 을 제외한 모든 오브젝트가 참으로 판별.
# 따라서 C / C++ 과 다르게 따라서 0 도 참이다.
if 0
  puts '0 is truthy'
end

if 'hello'
  puts 'string is also truthy'
end

# 한줄로 쓰고 싶을 땐 뒤에 조건을 써야한다.
puts 'a is zero' if a == 0

# If 의 반대에 해당하는 unless 도 있다.
puts 'a is not zero' unless a == 0

# 루비의 모든 구문은 값을 리턴한다. 따라서 다음과 같은 표현은
b = rand(3) # 0, 1, 2
if b == 0
  a = 'zero'
elsif b == 1
  a = 'one'
else
  a = 'two'
end

# 아래와 같이 다시 쓸 수 있다. 각 블락의 최종 값이 리턴 밸류가 됨.
# 할당문을 분기마다 반복할 필요가 없어 간결하고 실수의 여지도 줄일 수 있음.
a = if b == 0
      'zero'
    elsif b == 1
      'one'
    else
      'two'
    end

# 위와 같은 경우는 case 를 사용하는 것이 더 간결.
a = case b
    when 0
      'zero'
    when 1
      'one'
    else
      'two'
    end

# 각 when 구문을 한줄로 쓰려면 then 이 필요
a = case b
    when 0 then 'zero'
    when 1 then 'one'
    else 'two'
    end

# 조건을 결합할 때는 && 또는 || 를 사용한다.
if 0 && 'hello' || false
  puts 'yes!'
end

# 특이한 부분은 && 나 || 의 결과가 true / false 가 아니라 최종 object 라는 점
a = 'hello' && 'world'
b = 'hello' && nil || 100 && 200 || 'world'

# 이러한 점을 이용해 nil 체크를 간결하게 표현할 수 있다.
# 1. name 변수를 미리 정의하고 person 이 nil 이 아닐 때만 값을 할당 받는다
name = nil
if person != nil
  name = person.name
end

# 2. != nil 은 불필요하니 제거할 수 있다. if ~ end 가 값을 리턴하니 할당문을
#    한번만 쓰자
name = if person
         person.name
       end

# 3. && 가 값을 리턴한다는 점을 이용해 다음과 같이 쓸 수 있고
name = person && person.name

# 4. Ruby 2.3 에 추가된 &. 를 이용해 다음과 같이 더 짧게 쓸 수 있다.
name = person&.name

# 무한 loop. do ~ end 블락을 실행
loop do
  # Loop 중단
  break

  # C 나 Java 의 continue 와 달리 next 를 사용
  next
end

# do ~ end 블락은 { ~ } 로도 표현할 수 있다.
# 일반적으로 { ~ } 는 한줄짜리 표현식에 주로 사용하게 된다.
loop { break }

# while 구문
while rand(10) < 5
  # ...
end

# Method 정의
def add_two_numbers(a, b)
  a + b
end

# Method 호출
add_two_numbers(1, 2)

# 앞서 알아본 것 처럼 괄호는 optional 하다
add_two_numbers 1, 2

# 메소드 실행 시 커스텀한 동작을 코드 블락으로 전달하는 패턴이 많다
def do_something_with_two_values(a, b)
  puts "We're going to do something with #{a} and #{b}"
  yield a, b
end

do_something_with_two_values(1, 2) do |a, b|
  puts "#{a} + #{b} = #{a + b}"
end

do_something_with_two_values(1, 2) { |a, b| puts a - b }

10.times do |num|
  puts num
end

# Class 정의
class Foobar
  # Constructor
  def initialize(name)
    # Member variable
    @name = name
  end

  # Instance method
  def hello!
    puts "Hi, I'm #{@name}!"
  end

  # Class method
  def self.mister(name)
    Foobar.new('Mr. ' + name)
  end
end

f = Foobar.new('hadoop')
f.hello!

f = Foobar.mister('hadoop')
f.hello!

# 상수는 대문자를 사용
CONSTANT = 'hello'
```

Data types overview
-------------------

```ruby
# Integer
100
0xff

# Float
3.14

# String (single-quote)
'hello world'

# String (double-quote)
"1 + 2 = #{1 + 2}\n"
%(hello "world")

# TrueClass and FalseClass
true
false

# Symbol
:hello
:world

# Range
1..100
0x00..0xff
'a'..'z'

# Array
[1, 2, 3, 4, 5]
['hello', 'world']
%w(hello world)
[1, [2, 3, [4, 5, 6], 7], 8]

# Hash
{ 1 => 2, 3 => 4, :foo => 'hello', true => 3.14 }
{ :host => 'localhost', :port => 1234 }
{ host: 'localhost', port: 1234 }

# Regular expression
/foo.*bar/
%r(foo.*bar)
```

Kernel module
-------------

Ruby 는 object-oriented language 로 모든 것이 object 라고 하였으나, 앞의
예제에서 `puts`, `rand` 등은 `obj.puts` 같은 형태가 아니라 단독으로
사용되었다. 이러한 메소드들은 `Kernel` 이라는 모듈에 정의된 것으로 편의
상 명시적인 오브젝트 없이 사용할 수 있다.

> The Kernel module is included by class Object, so its methods are available
> in every Ruby object.

일단은 global function 이라고 생각하고 넘어가도 된다 (자세한 내용은
[여기에][global-functions]). Kernel 메소드들은 스크립팅 시 많이 사용된다.
중요한 것들만 알아보자.

[global-functions]: http://vaidehijoshi.github.io/blog/2015/05/12/investigating-rubys-global-functions-plus-kernel-module-with-puts/

https://ruby-doc.org/core-2.4.1/Kernel.html

```ruby
# Print
puts "Print string with newline"
print "Print string without newline"
printf "PI: %.6f\n", Math::PI

# Debug 에 유용한 형태 (obj.inspect) 로 출력
p "Print string with newline"
puts [1, 2, 3]
p [1, 2, 3]

# 커맨드라인 인자로 파일명이 주어졌을 경우 (ARGV.any?) 해당 파일의 라인을
# 한 줄 씩 읽고, 그렇지 않을 경우 (ARGV.empty?) STDIN 에서 읽는다.
# 필터 형태의 스크립트 작성 시 유용.
while line = gets
  puts line
end

# Random integer
rand(100)

# Sleep
sleep(10)

# Formatting
format('%05d', 123)
format('%.2f', Math::PI)

# External command
#  - true   ($? == 0)
#  - false  ($? != 0)
#  - nil    (Failed)
ok = system('ls -al')

# External command => String
result = `ls -al`
ok = $?.success?

# 프로그램 종료시 실행될 코드 등록
at_exit do
  puts 'goodbye sir'
end

# Exit
exit(1)
```

Data types
----------

### Numeric

- https://ruby-doc.org/core-2.4.1/Integer.html
- https://ruby-doc.org/core-2.4.1/Float.html

```ruby
# 숫자도 오브젝트이며
100.class
100.is_a?(Integer)

# 다양한 메소드들을 호출할 수 있음
100.methods

# ? 도 끝나는 메소드는 true/false 를 리턴한다
100.odd?
100.even?
100.zero?
100.positive?
100.negative?

# 사칙 연산
100 + 200 - 300

# 승수 계산
10 ** 3
8 * 1024 ** 3

# 정수 간의 나누기의 경우 내림 처리
12345 / 1000

# 소숫점 아래를 유지하고 싶을 때는 둘 중 하나를 소수로 표현
12345 / 1000.0

# String 변환
12345.to_s
'12345'.to_i

# Float
3.14.class
3.14.is_a?(Float)

3.14.ceil
3.14.floor
3.14.round
3.14.to_s

# times 메소드에 실행할 코드 블락을 전달
5.times do |num|
  puts num
end

# 블락이 없을 때는 Enumerator 를 리턴
enum = 5.times # Enumerator
enum.next
enum.next

# Enumerator 를 Array 로 변환
arr = enum.to_a

100.upto(110) do |num|
  puts num
end
```

### Range

https://ruby-doc.org/core-2.4.1/Range.html

```ruby
1..10
1...10

# 괄호를 사용하지 않으면 원하는 형태로 동작하지 않음
1..10.class    # 1..(10.class) 로 인식
(1..10).class

# Range 는 Enumerable 모듈을 include 하고 있다.
# (Java 에서 Iterable interface 를 구현하는 것과 유사)
range = 1..10
range.is_a?(Enumerable)

# 따라서 Enumerable 모듈이 제공하는 each 를 비롯한 다양한
# 메소드들을 사용할 수 있다. each, min, max, count, each_slice, ...
# - https://ruby-doc.org/core-2.4.1/Enumerable.html
range.each do |num|
  puts num
end

# Pry 상에서 `ls range` 를 통해 어떤 메소드들이 있는지 확인 가능하다
range.max
range.min
range.count
range.take(5)
range.to_a
range.each_slice(3) do |slice|
  p slice
end
range.each_cons(3) do |slice|
  p slice
end
```

### String

https://ruby-doc.org/core-2.4.1/String.html

```ruby
str = '/Users/foo/bar'
str.length
str.upcase
str.downcase
str.empty?
str.reverse
str.split('/')
str.start_with?('/Users')
str.end_with?('bar')
str.sub('/', '@')
str.gsub('/', '@')
str.chomp
str.strip

str.each_char do |c|
  puts c
end
chars = str.each_char.to_a

# 스트링 결합
'hello' + ' ' + 'world'
['hello', ' ', 'world'].join
['hello', 'world'].join(' ')

# 스트링 반복
banner = 'hello world'
puts banner, '-' * banner.length

# 여러 줄에 걸친 스트링은 그냥 다음과 같이 쓰면 된다.
a = "hello
world
goodbye
world"

# Bash 의 here-document 같은 문법도 있다.
str = <<EOF
hello
world
goodbye
world
EOF

# 그런데 위의 방식들은 들여쓰기가 있을 경우 매우 보기 안 좋아진다.
class Foo
  def foo
    puts <<EOF
hello
world
goodbye
world
EOF
  end

  # 이에 Ruby 2.3 에서는 다음과 같은 방식이 추가되었다.
  def bar
    puts <<~EOF
      hello
      world
      goodbye
      world
    EOF
  end
end

# String 의 한 라인씩 접근하고 싶을 땐
# New-line characer 로 split 해 Array 를 만들 수도 있고
arr = str.split("\n")

# 더 간단하게는 lines 메소드를 사용하면 된다
arr = str.lines

# 그러나 이 경우 전체 스트링을 처리해서 array 를 만들기 때문에 일부분만 필요한
# 경우에는 불필요한 작업을 하게 된다. each_line 메소드를 이용해 Enumerator
# 를 얻거나 코드 블락을 실행시킬 수 있다
puts str.each_line.take(1)

str.each_line do |line|
  puts line
  break
end

# Enumerator 는 with_index 라는 메소드를 가지고 있어 다음과 같이 조합할 수도
# 있다.
str.each_line.with_index do |line, index|
  puts line
  break if index == 3
end
```

### Regexp

https://ruby-doc.org/core-2.4.1/Regexp.html

```ruby
# 기본적으로 / 사이에 정규표현식을 기재하면 Regexp 가 된다
regex = /foo.*bar/
regex.class

# 매칭된 스트링이 발견된 위치 (3) 를 리턴
regex =~ '1. foo 2. bar'

# String 에도 동일하게 =~ 메소드가 있으므로 순서가 뒤집혀도 된다.
'1. foo 2. bar'=~ regex

# 대소문자 구분이 필요 없는 경우는 i 를 뒤에 붙임
/foo.*bar/i =~ "FooBAR"

# 매칭되지 않으면 nil 을 리턴하므로 다음과 같은 형태로 많이 사용된다.
if some_string =~ /foo|bar/
  # ...
end

# 정규표현식에 / 를 사용해야 하는 경우는 \/ 형태로 escaping 필요
regex = /^\/usr\/[^\/]+\/bin/
'/usr/local/bin'.match?(regex) # match? 는 true / false 를 리턴

# 사용하기 어려우므로 %r( ... ) %r{ ... } %r[ ... ] 등으로 기술할 수 있다
regex = %r(^/usr/[^/]+/bin)
'/usr/local/bin'.match?(regex)

# 괄호를 이용해 매칭된 substring 를 추출
regex = %r(^/usr/([^/]+)/bin)
match_data = '/usr/local/bin'.match(regex)
match_data[0]
match_data[1]

# 매칭이 되지 않으면 nil 을 리턴한다
'apple'.match(/orange/)

# 정규표현식은 스트링 치환에 많이 쓰인다
string = 'I have 10 apples and 20 oranges'
string.sub(/[0-9]+ /, '')
string.gsub(/[0-9]+ /, '')

# 매칭된 영역을 잡아서 \1, \2, ... 로 참조할 수 있다
string.gsub(/([0-9]+) ([a-z]+)s/, '1, not \1, \2')

# 코드 블락을 이용해 더 복잡한 로직을 구현해 볼 수도 있다.
string.gsub(/([0-9]+) ([a-z]+)s/) do |s|
  count = $1.to_i * 2
  fruit = $2.upcase
  "#{count} #{fruit}s"
end

string.gsub(/[0-9]+ ([a-z]+)s/, '1 \1')
```

### Array

https://ruby-doc.org/core-2.4.1/Array.html

```ruby
# [ ~ ] 로 적는다
arr = ['foo', 'bar', 'baz']

# String 단어만으로 구성된 array 의 경우 아래와 같이
# %w( ... ) %w[ ... ] 등으로 간결하게 표현 가능
arr = %w(foo bar baz)

# Enumerable 한 object 에 대해 to_a 메소드를 호출해서 만들 수도 있다.
arr = 'hello world'.each_char.to_a
arr = (1..100).to_a

# Array methods
arr.empty?
arr.any?
arr.length
arr.join('-')
arr.first
arr.last
arr.sample
arr.reverse
arr.shuffle
arr.shuffle.sort
arr.rotate
arr.rotate(2)
arr.uniq
[1, nil, 2, nil, 3, 3, 3].compact.uniq
[[1, 2, 3, 4], [5, 6, 7, 8]].transpose

# Range 와 마찬가지로 Enumerable 이므로 Enumerable 모듈 메소드들 사용 가능
# Enumerable 에 대해서는 뒤에서 더 자세히.
arr.min
arr.max

# 값 확인
arr = [10, 20, 30, 40, 30, 20, 10]
arr[0]
arr[1]
arr[-1]
arr[-2]
arr.values_at(0, 1, -1, -2)
arr.include?(30)
arr.index(30)
arr.rindex(30)
arr.index(100)

# 다차원 배열을 사용하는데도 제한이 없다
arr = [1, 2, [3, 4], [5, [6, 7]]]

# 평평하게
arr.flatten

# 합치기
[1, 2, 3] + [4, 5, 6]

# Mutating array (자기 자신을 리턴)
arr = []
arr << 1 << 2
arr.push(3, 4, 5).push(6, 7, 8)
tail = arr.pop
head = arr.shift
arr.unshift(-1, -2, -3)
arr.concat([:hello, :world])

```

### Hash

- https://ruby-doc.org/core-2.4.1/Hash.html
- https://ruby-doc.org/core-2.4.1/Symbol.html

```ruby
# Key-value 매핑
h = { 1 => 2, 3 => 4, 5 => 6 }
h[3]
h[5] = 7

h
h.keys
h.values

h.each do |k, v|
  puts "Value for #{k} is #{v}"
end

# 간단한 자료 구조를 나타낼 때 별도의 클래스를 만들어 사용하지 않고 Hash 를
# 이용하는 경우가 자주 있다. 일반적으로 Symbol 을 key 로 많이 활용한다.
# Symbol 은 Java 의 enum 에 상응하는 개념으로 이해하면 된다.
h = { :host => 'localhost', :port => 1234 }
h[:host]

# Symbol 도 object 이지만 동일한 이름의 Symbol 은 단 하나의 오브젝트이기
# 때문에 String 을 사용하는 것보다 효율적이다.
:host.object_id == :host.object_id
'host'.object_id == 'host'.object_id

# Symbol 을 key 로 사용하는 경우가 많으므로 좀 더 간결하게 쓸 수 있도록 다음과
# 같은 문법을 지원한다.
h = { host: 'localhost', port: 1234 }

# Hash methods

# 키를 가지고 있는지 체크
h.has_key? :host

# 다른 Hash 와 merge 해 새로운 Hash 를 리턴
h2 = h.merge({ protocol: 'https' })

# 다음과 같이 하나씩 액세스 가능하지만
host = h2[:host]
port = h2[:port]
protocol = h2[:protocol]

# values_at 으로 한번에 여러 값을 가져올 수도 있다.
host, port, protocol = h2.values_at(:host, :port, :protocol)

# 없는 키에 대해 접근하면 nil 이 리턴됨.
user = h2[:user]

# 에러가 나길 원한다면 fetch 메소드를 쓰면 된다.
h2.fetch(:user)
  # KeyError: key not found: :user

# fetch 메소드에 디폴트 값을 줄 수도 있는데
h2.fetch(:user, 'anonymous')

# 단순히 이렇게 사용하기도 한다
h2[:user] || 'anonymous'
```

Constants and global variables
------------------------------

https://ruby-doc.org/core-2.4.1/doc/globals_rdoc.html

- `RUBY_VERSION`
- `RUBY_PLATFORM`
- `ARGV`
- `ENV`
- `__FILE__`
- `__LINE__`
- `$0`
- `$stdout`
- `$stderr`
- `$stdin`

```ruby
#!/usr/bin/env ruby

puts ARGV
puts ENV['HOME']

$stdin.each_line do |line|
  puts "Executing code @ #{__FILE__}:#{__LINE__}"
  puts "#{line} (#{line.length})"
end
```

Exception 처리
--------------

https://ruby-doc.org/core-2.4.1/Exception.html

```ruby
begin
  no_such_method
rescue NameError => e
  puts e
  puts e.backtrace
rescue Exception => e
  # 그외 모든 나머지 exception
ensure
  # Finally
end

# Exception 을 던질 때는 `raise` 를 사용한다.
raise ArgumentError.new('no, no')

# 아래와 같이 쓸 수도 있다.
raise ArgumentError, 'no, no'

# Exception 클래스를 지정하지 않으면 RuntimeError 가 사용된다.
raise 'no, no'

# begin ~ end 블락을 사용하지 않고 rescue 한 줄로 익셉션을 처리할 수도 있다.
# 이 때는 StandardError 하위의 타입만 잡히는 것을 유의.
value = no_such_method rescue nil
```

Core classes and modules
------------------------

https://ruby-doc.org/core-2.4.1/

### File / Dir

- https://ruby-doc.org/core-2.4.1/File.html
- https://ruby-doc.org/core-2.4.1/Dir.html

```ruby
# File: class methods
File.exist?('README.md')
File.readable?('README.md')
File.size?('README.md')
File.symlink?('README.md')
File.executable?('/bin/bash')
File.directory?('/bin')

File.extname('README.md')
File.basename('/usr/local/bin/bash')
File.dirname('/usr/local/bin/bash')

File.expand_path('~/work')
File.expand_path('../../abc')
File.expand_path('..', __FILE__)

# Dir
Dir.pwd
files = Dir['**/*.md']

# File 읽기, 전체를 한번에 하나의 스트링으로
data = File.read('README.md')

# 라인의 Array 로 읽기
lines = File.readlines('README.md')

# File object 사용
file = File.open('test', 'w')
# puts 나 print 사용
file.puts 'hello'
file.puts 'world'
file.print '!!!'
# << 를 사용할 수도 있다
file << 123 << 456
# File 에 대한 작업을 마치면 반드시 close 해야한다
file.close

# 코드 블락을 이용해 자동으로 close 하는 것을 보장할 수 있다
# 'a' mode 로 append 할 수 있다
File.open('test', 'a') do |file|
  file.puts 'goodeby'
  file.puts 'world'
end

# 한줄씩
File.open('README.md') do |file|
  file.each_line do |line|
    puts line
  end
end

# 몇줄만
File.open('README.md') do |file|
  file.each_line.with_index do |line, index|
    puts line
    break if index == 10
  end
end
```

### Enumerable

https://ruby-doc.org/core-2.4.1/Enumerable.html

```ruby
lines = File.readlines('/usr/share/dict/words')

# 최초 다섯개 확인, 모두 newline 캐릭터가 붙어 있다.
lines.take(5)

# 제거하자
words = lines.map { |line| line.chomp }

words.count
words.min
words.max
words.include?('apple')

# 최초 다섯개
words.take(5)

# 100 개만 랜덤하게 뽑으려면?
samples = words.shuffle.take(100)
samples.include?('apple')

# 대문자로 시작하는 단어가 있는가?
uppers = samples.select { |w| w =~ /^[A-Z]/ }

# select 의 반대
lowers = samples.reject { |w| w =~ /^[A-Z]/ }

# 한방에 하자
uppers, lowers = samples.partition { |w| w =~ /^[A-Z]/ }
uppers.count
lowers.count

# 단순 정렬
samples.sort

# 정렬 기준을 코드 블락으로 전달할 수 있다
samples.sort_by { |w| w.length }

# 다차원 정렬 기준이 필요한 경우는 코드 블락이 Array 를 리턴하게 하면 됨
# - 길이 역순, 길이가 같은 경우는 알파벳순
samples.sort_by { |w| [-w.length, w] }

# 길이 기준으로 그루핑해보자
grouped = samples.group_by { |w| w.length }

# 첫글자로 그루핑하기
grouped = samples.group_by { |w| w[0] }
grouped['a'].join(', ')

grouped.each do |length, words|
  puts "Length: #{length} => #{words.count} word(s)"
end
grouped.sort
```

#### Map-reduce 패턴

1 부터 100까지의 수 중에서 짝수를 뽑아, 각 수의 제곱을 더한 값을 구해보자

- `2 * 2 + 4 * 4 + 6 * 6 + ... + 100 * 100`

```ruby
# 1 부터 100 까지의 수가 있을 때
nums = (1..100)

# 짝수인 경우만 택하자
evens = nums.select { |num| num % 2 == 0 }

# even? 메소드를 써도 동일한데
evens = nums.select { |num| num.even? }

# 이렇게 인자 없이 메소드 호출하는 경우는 다음과 같이 축약해 쓰는 문법이 있다.
evens = nums.select(&:even?)

# 각 숫자를 각 숫자의 제곱으로 변환해야 한다.
squares = evens.map { |num| num ** 2 }

# reduce 메소드를 이용해 값을 더해나간다
sum = squares.reduce(0) { |sum, num| sum + num }
  # 0 은 초기값
  # nums 를 따라가며 sum 과 num 에 값을 대입하고 코드 블락의 결과를 다음 sum
  # 으로 사용한다

# 초기값을 주지 않을 경우는 nums 의 첫번째를 sum 으로, 두번째를 num 으로 시작한다
# 이 경우에는 결과가 동일
sum = squares.reduce { |sum, num| sum + num }

# 더 줄여쓸 수도 있다
sum = squares.reduce(:+)

# 위에서 한 작업을 이어서 쓰면 이런 형태가 된다
sum = (1..100).select { |n| n.even? }.map { |n| n ** 2 }.reduce { |sum, n| sum + n }

# 축약하면
sum = (1..100).select(&:even?).map { |n| n ** 2 }.reduce(:+)
```

다음과 같은 예제도 살펴보자.

```ruby
# 유사한 예제
(1..10).map(&:to_s).reduce(:+)

# 또 다른 예제
%w{ cat sheep bear }.reduce do |longest, word|
  longest.length > word.length ? longest : word
end
```

조금 더 현실적인 예제로 다음과 같은 경우를 생각해보자. `/usr/bin/`
과 `/usr/local/bin` 의 모든 파일들의 크기를 더해보자.

```ruby
paths = %w{ /usr/bin /usr/local/bin }
files = paths.map { |path| Dir[path + '/*'] }
files = files.flatten

# map + flatten 대신 flat_map 으로 한번에 할 수도 있다
files = paths.flat_map { |path| Dir[path + '/*'] }

# 사이즈의 어레이로 변환한다
# File.size? 는 파일 크기가 0 일 경우 nil 을 리턴한다 (왜?)
# 따라서 이에 대한 처리를 해야 되는데 두가지 접근이 있을 수 있다.
# 1. Array 에서 nil 인 것들을 제거하는 compat 메소드를 사용한다
sizes = files.map { |file| File.size?(file) }
sizes = sizes.compact

# 2. 위에서 File.size? 가 nil 을 리턴할 경우 0 이 되도록 하자
sizes = files.map { |file| File.size?(file) || 0 }

# 이제 위에서와 같이 합을 구할 수 있다
size_sum = sizes.reduce(:+)
```

#### Lazy enumerator

Enumerable 메소드를 이어서 만든 로직은 간결하고 가독성이 좋지만 불필요한
작업을 수행하게 될 수 있다.

```ruby
require 'open-uri'

# 다음 URL 리스트에서
urls = %w(https://www.google.com
          http://www.daum.net
          http://www.naver.com)

# "대선" 이라는 단어를 가진 첫번째 URL 을 찾는다.
page = urls.map { |url| open(url).read }.select { |data| data.include?('대선') }.first
```

위의 코드의 문제는 해당 조건에 맞는 페이지를 찾은 이후에도 나머지 URL 들을
모두 접근한다는 점이다. Lazy enumerator 를 이용하여 필요한 만큼만 평가되도록
할 수 있다.

```ruby
page = urls.lazy.map { |url| open(url).read }.select { |data| data.include?('대선') }.first
```

리스트의 일부를 취하는 `first`, `take`, `take_while` 등과 주로 사용하게
될 것이다.

```ruby
# lazy 가 있을 때와 없을 때를 비교해볼 것
(1..20).lazy.
  select { |e| puts "#{e}.odd?"; e.odd? }.
  select { |e| puts "#{e} < 10"; e < 20 }.
  map    { |e| puts "#{e} * 2";  e * 2 }.
  take(5).to_a
```

### Time

https://ruby-doc.org/core-2.4.1/Time.html

```ruby
# 현재 시간을 Time 오브젝트로 리턴
Time.now

# 현재 시간의 Unix timestamp 를 구한다 (초단위)
Time.now.to_i

# 더 세밀한 시간을 얻고 싶을 때
Time.now.to_f

# 반대로 Time object 를 unix timestamp 로부터 만들 수 있고
epoch = Time.at(0)

# 시간을 지정할 수도 있다.
time = Time.new(2017, 1, 1, 12, 30, 45)

# UTC 시간으로 변경하려면
utc_time = time.utc

# 이를 다시 localtime 으로 변경할 수도 있다
time = utc_time.localtime

# 아니면 처음부터 new 대신 utc 로 만들어도 된다
utc_time = Time.utc(2017, 1, 1, 12, 30, 45)

# 요일을 확인하는 메소드도 있고
time.monday?
time.tuesday?

# 개별 단위를 받아올 수도 있다.
time.year
time.month
time.day

# 포매팅할 때는 strftime
Time.now.strftime('%Y-%m-%d %H:%M:%S.%L')

# 시간 차이를 계산하는 것도 간단하다
diff_in_sec = Time.now - Time.new(2017, 1, 1)
diff_in_hour = diff_in_sec / 60 / 60
```

### IO

https://ruby-doc.org/core-2.4.1/IO.html

I/O 에 근간이 되는 클래스로 File 의 상위 클래스이다.

```ruby
$stdin.class
$stdout.class

file = File.open('/tmp/new', 'w')
file.is_a? IO
```

파일 읽고 쓰는데 주로 사용되는 메소드가 많은데, child process 를 만들고 다루는
`IO.popen` 같은 메소드도 알아두면 좋다.

```ruby
def with_filter(command)
  IO.popen(command, 'r+') do |io|
    begin
      stdout, $stdout = $stdout, io
      yield rescue nil
    ensure
      $stdout = stdout
    end
    io.close_write
    io.readlines.map(&:chomp)
  end
end

with_filter('fzf -m --tac') do
  1000.times do |n|
    puts n
    sleep 0.01
  end
end
```
Standard libraries
------------------

https://ruby-doc.org/stdlib-2.4.1/

### Message digests

- https://ruby-doc.org/stdlib-2.4.1/libdoc/base64/rdoc/Base64.html
- https://ruby-doc.org/stdlib-2.4.1/libdoc/digest/rdoc/Digest.html

```ruby
require 'base64'

data = File.read('README.md')

Base64.encode64(data)
Base64.decode64(Base64.encode64(data)) == data

require 'digest'

# MD5
Digest::MD5.hexdigest(data)

# SHA1
Digest::SHA1.hexdigest(data)

# SHA256
Digest::SHA256.hexdigest(data)
```

### Benchmark

```ruby
require 'benchmark'
result = Benchmark.measure do
  sleep 2
end
puts result
puts result.real
puts result.utime
puts result.stime
```

### PP (Pretty Print)

```ruby
require 'pp'
files = Dir["#{ENV['HOME']}/github/hbase/**/*"]
pp files
```

### Set

- https://ruby-doc.org/stdlib-2.4.1/libdoc/set/rdoc/Set.html

```ruby
require 'set'
set1 = Set.new [1, 2, 3]
set2 = Set.new [3, 4, 5]

set1.intersection(set2)
set1.difference(set2)
set1.union(set2)
set1.subset?(set2)

set1.subset?(set1.union(set2))
set1.union(set2).superset?(set1)
```

### Time

Time 은 기본적으로 제공되는 클래스지만, 일부 추가기능을 사용하기 위해서는
명시적으로 `require 'time'` 을 해주어야 한다.

https://ruby-doc.org/stdlib-2.4.1/libdoc/time/rdoc/Time.html

```ruby
require 'time'
# 이제 Time#parse 메소드 사용 가능
time = Time.parse '2017-04-03T02:00:30.300Z'
```

### OpenURI / JSON

- https://ruby-doc.org/stdlib-2.4.1/libdoc/open-uri/rdoc/OpenURI.html
- http://ruby-doc.org/stdlib-2.4.1/libdoc/json/rdoc/JSON.html

```ruby
require 'open-uri'
require 'json'
require 'pp'
data = open('http://chronos.hbase.dkos.9rum.cc/v1/scheduler/jobs').read
json = JSON.parse(data)
json.class
json.count
json.first['name']
json.map { |job| job['name'] }

# JSON 의 키를 스트링이 아닌 심볼로 읽고 싶으면 다음과 같이 적는다
json = JSON.parse(data, symbolize_names: true)
json.map { |job| job[:name] }

JSON.dump({hello: 1, world: 2})
```

### More

- https://ruby-doc.org/stdlib-2.4.1/libdoc/fileutils/rdoc/FileUtils.html
- https://ruby-doc.org/stdlib-2.4.1/libdoc/csv/rdoc/CSV.html
- https://ruby-doc.org/stdlib-2.4.1/libdoc/net/http/rdoc/Net/HTTP.html
- https://ruby-doc.org/stdlib-2.4.1/libdoc/pathname/rdoc/Pathname.html
- https://ruby-doc.org/stdlib-2.4.1/libdoc/yaml/rdoc/YAML.html
- https://ruby-doc.org/stdlib-2.4.1/libdoc/shellwords/rdoc/Shellwords.html

Thread
------

Ruby 에는 thread 가 있지만 [Global Interpreter Lock][GIL] 때문에 코어를
하나밖에 사용하지 못한다 (이는 Python 도 동일). 따라서 연산량이 많은 경우에
thread 를 사용하는 것은 의미 없지만 I/O 작업을 병렬화하는데는 유용하게 사용할
수 있다.

참고로 JVM 상에서 동작하는 JRuby 의 경우 여러 코어를 사용 가능하다.

[GIL]: https://en.wikipedia.org/wiki/Global_interpreter_lock

```ruby
t = Thread.new do
  sleep 5
  'good morning'
end
result = t.value

values = 16.times.map do |i|
  Thread.new do
    name = "thread #{i}"
    puts "#{name} started"

    sleep_time = rand
    sleep(sleep_time)

    puts "#{name} finished"
    sleep_time
  end
end.map(&:value)
```

[`Queue`](https://ruby-doc.org/core-2.4.1/Queue.html) 를 이용해 간단한
thread pool 을 구현해 볼 수 있다.

```ruby
require 'thread'
queue = Queue.new
16.times do |i|
  Thread.new do
    loop do
      item = queue.shift

      puts "Thread #{i} will process #{item}"
      sleep rand
      puts "Thread #{i} finished processing #{item}"
    end
  end
end

100.times do |i|
  queue.push i
end
```

상대적으로 Ruby 는 multi-threading 을 위한 기본 라이브러리가 빈약한 편이다.
이는 다음 프로젝트와 같은 외부 라이브러리로 보완할 수 있다.

- https://github.com/ruby-concurrency/concurrent-ruby
    - http://ruby-concurrency.github.io/concurrent-ruby/file.thread_pools.html

라이브러리 시스템
----------------

각 라이브러리는 gem 이라고 불리며 [Rubygems](https://rubygems.org/)
에 등록되어 있다. `gem` 커맨드를 통해 설치할 수 있다.

```sh
gem install gimchi
```

```ruby
require 'gimchi'
Gimchi.romanize '한글의 로마자 표기'
```

그런데 각 프로젝트 별로 필요한 gem 버젼이 다르고, 각 gem 간의 디펜던시가 있기
때문에 gem dependency 관리를 위해 [Bundler](http://bundler.io/) 라는 툴을
이용하게 된다. Bundler 역시 gem 으로 설치한다.

```sh
gem install bundler
```

`Gemfile` 을 생성해서 다음과 같이 필요한 gem 과 그 버젼들을 기재한다.

```
source 'https://rubygems.org'
gem 'nokogiri'
gem 'rack', '~> 2.0.1'
gem 'rspec'
```

이후 `bundle install` 을 실행하면 해당 조건에 맞는 gem 들이 설치되며 설치된
정보가 `Gemfile.lock` 으로 기록된다. 이제 스크립트 상단에 다음 코드를 추가하면
고정된 gem 버젼 디펜던시를 가진 환경으로 실행할 수 있다.

```ruby
require 'bundler/setup'
```

프로젝트 레이아웃
----------------

### 단순 스크립트

특별히 구조를 갖출 필요가 없다. 특히 외부 라이브러리 (gem) 을 사용하지 않을
경우 더욱 간단하며 단일 파일로 만들어 실행하면 된다.

### 일반적인 프로젝트

강제되는 구조는 없지만 일반적으로는 다음과 같은 모양.

```sh
hadoop/
├── Gemfile
├── bin
│   ├── start-hbase
│   └── start-hdfs
├── lib
│   ├── hadoop
│   │   ├── hbase
│   │   │   ├── master.rb
│   │   │   └── regionserver.rb
│   │   ├── hbase.rb
│   │   ├── hdfs
│   │   │   ├── datanode.rb
│   │   │   └── namenode.rb
│   │   ├── hdfs.rb
│   │   ├── mapreduce.rb
│   │   ├── yarn
│   │   │   ├── nm.rb
│   │   │   └── rm.rb
│   │   └── zookeeper.rb
│   └── hadoop.rb
└── test
    ├── hadoop
    │   ├── test_hbase.rb
    │   ├── test_hdfs.rb
    │   └── test_zookeeper.rb
    └── test_helper.rb
```

`bin/start-hbase` 의 경우 상단에 다음과 같은 라인들이 있을 것이다.

```ruby
require_relative '../lib/hadoop'
require_relative '../lib/hadoop/hbase'

Hadoop::HBase.start(ARGV)
```

`lib/hadoop.rb` 에는 보통 하위의 파일들을 로드하는 구문들이 나열된다.

```ruby
require_relative 'hadoop/hdfs'
require_relative 'hadoop/hbase'
require_relative 'hadoop/mapreduce'
require_relative 'hadoop/yarn/nm'
require_relative 'hadoop/yarn/rm'
require_relative 'hadoop/zookeeper'
```

특수 문법
---------

### Splat operator (`*`)

```ruby
# 가변길이 파라미터를 Array 형태로 처리할 수 있다
def say(hello, *people)
  puts people.map { |p| [hello, p, '!'].join(' ') }
end

# say('Hello', ['Alice', 'Bob', 'Carol'])
say('Hello', 'Alice', 'Bob', 'Carol')

# 메소드가 가변길이 파라미터를 요구하지만 Array 를 가지고 있을 때는 반대로
# Array 를 가변길이 파라미터로 변환해 전달할 수 있다.
say('Hello', *['Alice', 'Bob', 'Carol'])

# 변수 할당 시에도 사용할 수 있다.
first, second, *rest = [1, 2, 3, 4, 5]

# Array 를 만들 때도 사용
[1, *(2..9), 10]

# x 는 Array 일수도 있고 아닐 수도 있다
x = rand(2) == 0 ? 1 : [1, 2, 3]

y = [*x]
  # [*1]         => [1]
  # [*[1, 2, 3]] => [1, 2, 3]
```

#### 참고

http://jacopretorius.net/2012/01/splat-operator-in-ruby.html

### `&` symbol

```ruby
%w(alice bob).map { |s| s.length }
```

위의 표현은 아래와 같이 축약해 쓸 수 있다.

```ruby
%w(alice bob).map(&:length)
```

이런 표현은 생소할 수 있겠으나 `&` 는 Ruby 에서 코드 블락에 관련된 것이라
이해하면 좋다. 코드 블락을 받는 메소드는 아래와 같이 두가지 방법으로 선언할
수 있다.

```ruby
# 코드 블락에 a ** b 를 전달해 실행한다
def with_power(a, b)
  # 명시적인 이름 없이 block_given? 과 yield 를 이용해 코드 블락을 실행한다.
  if block_given?
    yield(a ** b)
  end
end

with_power(2, 10) do |value|
  puts "Kilo is #{value}"
end

# 코드 블락을 이름으로 참조하고자 할 때는 아래와 같이 & 를 사용할 수 있다.
def with_power(a, b, &blk)
  # & 는 코드 블락을 Proc 오브젝트로 변환하는 역할을 하며 Proc 오브젝트를
  # 실행할 때는 Proc#call 메소드를 사용한다.
  if blk
    blk.call(a ** b)
  end
end
```

위 방식의 장점은 명시적이고, 코드블락을 오브젝트 형태로 다룰 수 있다는 점이다.
이를 다른 메소드에 전달하거나 특정 변수에 저장해 놓는 경우들을 생각해
볼 수 있다. Proc 오브젝트를 블락 형태로 메소드에 전달하기 위해선 역시 `&`
를 사용하게 된다.

```ruby
with_something_else(a, b, &blk)
```

다시 말해 `&` 는 Proc 오브젝트와 코드블락 사이의 양방향 변환에 쓰인다.

이와 연관지어 앞에서 이야기한 `&:length` 를 이해해 볼 수 있다.

1. `Enumerable#map` 은 코드블락을 받는 메소드이다.
2. 우리가 가진 오브젝트를 코드 블락 형태로 변환하려면 `&` 를 붙여야 한다.
3. `&` 는 뒤에 따르는 오브젝트가 Proc 이 아닌 경우에는 `to_proc` 메소드를
   먼저 호출한다.

따라서 위의 구문은

1. `:length.to_proc` 으로 Proc 오브젝트를 얻고
2. 이렇게 얻은 Proc 오브젝트를 `&` 를 이용해 코드 블락으로 변환해
3. `Enumerable#map` 으로 전달하는 것이다.

Symbol 의 `to_proc` 메소드는 어떤 오브젝트를 받아 해당 오브젝트의 심볼 이름의
메소드를 호출하는 `Proc` 을 리턴한다.

```ruby
length_method = :length.to_proc
length_method.call('alice')
length_method.call('bob')
```


#### 참고

http://stackoverflow.com/questions/1961030/ruby-ampersand-colon-shortcut

### Keyword argument

전통적으로 루비에선 Hash 를 이용해 메소드 파라미터를 전달하는 경우가 많다.

```ruby
require 'open-uri'

def http_get(url, opts = {})
  user, password, port = opts.values_at :user, :password, :port

  # 에러 처리
  raise ArgumentError, 'missing keyword: user' unless user

  # 디폴트 값 처리
  port ||= 80
  # ...
end
```

간단한 방법이기는 하나 어떤 key 가 요구/허용되는지 명시적이지 않고, key 별로
디폴트 값을 지정하는 것이 번거롭다. 이 때문에 Ruby 2.0 부터는 keyword argument
를 지원하게 되었다.

```ruby
# 디폴트 값이 주어지지 않으면 반드시 주어져야 한다는 의미 (Ruby 2.1 이상)
def http_get(url, user:, password: nil, port: 80)
  # ...
end

# 호출 시 키워드의 순서는 중요하지 않다
http_get('kakao.com', port: 1010, user: 'anonymous')

# 허용되지 않은 키워드가 나오면 에러
http_get('kakao.com', port: 1010, user: 'anonymous', foo: 'bar')
  # ArgumentError: unknown keyword: foo
```

명시적으로 지정하지 않고 다른 key-value 들을 참조하고 싶을 때는 `**` 표현을
사용하면 된다.

```ruby
# 나머지 값들의 Hash 를 rest 로 참조할 수 있다.
def http_get(url, user:, password: nil, port: 80, **rest)
  # ...
  p rest
end

http_get('kakao.com', port: 1010, user: 'anonymous', foo: 'bar')
```

Module
------

https://ruby-doc.org/core-2.4.1/Module.html
http://ruby-doc.com/docs/ProgrammingRuby/html/tut_modules.html

> A Module is a collection of methods and constants.

모듈은 상수, module function, instance method 를 가질 수 있으며

- 클래스에 기능을 주입하는 용도 ([Mixin](https://en.wikipedia.org/wiki/Mixin)) 와
- 네임스페이스 용도로 사용된다.

> In object-oriented programming languages, a mixin is a class that contains
> methods for use by other classes without having to be the parent class of
> those other classes.

### Mixin

```ruby
module Reporter
  def report
    puts <<~EOF
      Class: #{self.class}
      Object ID: #{object_id}
      Methods: #{methods}
    EOF
  end
end

class Foo
  include Reporter
  def name
    'foo'
  end
end

Foo.new.report

class String
  include Reporter
end

'any string'.report
```

### Namespace

```ruby
module Doopey
  VERSION = 'cdh5'

  def self.support?(version)
    version > VERSION
  end

  module HDFS
    HTTP_PORT = '50070'

    class Client
      # ...
    end
  end
end

Doopey::VERSION
Doopey.support?('cdh4')

Doopey::HDFS::HTTP_PORT
Doopey::HDFS::Client.new
```

문서화
------

루비 코드의 API 문서는 rdoc 또는 [yard](https://github.com/lsegal/yard)
를 이용해 생성한다. yard 는 별도 설치가 필요하니 rdoc 에 대해 먼저 익히도록
한다.

- https://rdoc.github.io/rdoc/
- https://rdoc.github.io/rdoc/RDoc/Markup.html

다음과 같은 예제를 참고하자.

- https://github.com/rails/rails/blob/master/activemodel/lib/active_model/validations.rb
    - http://api.rubyonrails.org/classes/ActiveRecord/Validations.html

기본 RDoc 과는 화면 스타일이 다른 것을 볼 수 있는데, Rails 프로젝트의 경우
RDoc 을 기반으로 만들어진 [SDoc](https://github.com/zzak/sdoc) 을 이용해
문서를 만든다.

```sh
gem install sdoc
sdoc --template rails
```

테스트
------

- https://github.com/seattlerb/minitest
- http://docs.seattlerb.org/minitest/

일반적인 프로젝트에서 루비 소스 코드는 `lib` 디렉토리에 테스트 코드는 `test`
([혹은 `spec`][test-vs-spec], 혹은 복수형) 디렉토리에 위치시킨다. 이는
일반적인 컨벤션이므로 반드시 따라야 하는 것은 아니다.

[test-vs-spec]: https://sites.google.com/site/unclebobconsultingllc/specs-vs-tests

```ruby
# lib/foo.rb

class Foo
  def name
    'foo'
  end

  def self.bar_or_baz
    rand(2).zero? ? 'bar' : 'baz'
  end
end
```

```ruby
# test/test_foo.rb

require 'minitest/autorun'
require_relative '../lib/foo'

class TestFoo < Minitest::Test
  def setup
    @foo = Foo.new
  end

  def teardown
  end

  def test_that_foo_returns_foo
    assert_equal 'foo', @foo.name
  end

  def test_bar_or_baz
  end
    assert_match /ba[rz]/, Foo.bar_or_baz

  def test_that_will_be_skipped
    skip 'test this later'
  end
end
```

사용 가능한 assertion 의 목록은 [문서를 참고][assertions]하거나 pry 에서
`require 'minitest'` 후 `ls Minitest::Assertion` 으로 확인하자.

[assertions]: http://docs.seattlerb.org/minitest/Minitest/Assertions.html

여러 테스트 파일을 한번에 실행해야 할 경우 개별 파일들을 로드 (`require`,
`require_relative`, 혹은 `load`) 하는 별도의 스크립트를 만들어 실행할 수 있다.

```ruby
Dir.glob(File.expand_path('../test_*.rb', __FILE__)).each do |file|
  require file
end
```

혹은 Rake 라는 루비 빌드 시스템을 이용할 수도 있다. Rakefile 을 프로젝트
디렉토리에 만들고 다음과 같은 내용을 적은 후

```ruby
require 'rake/testtask'

Rake::TestTask.new do |t|
end
  t.pattern = 'test/test_*.rb'
```

`rake test` 로 실행할 수 있다.

연습문제
--------

### 검열 필터 1

STDIN 을 읽어 숫자 부분을 `*` 로 치환하는 필터를 만들어 보자.

```
$ ls -al | ./redact-number.rb

total **
drwxr-xr-x    * jg  staff    *** Apr  * **:** .
drwxr-xr-x@ *** jg  staff   **** Mar ** **:** ..
drwxr-xr-x   ** jg  staff    *** Apr  * **:** .git
-rw-r--r--    * jg  staff  ***** Apr  * **:** README.md
drwxr-xr-x    * jg  staff    *** Apr  * **:** books
drwxr-xr-x    * jg  staff    *** Apr  * **:** examples
-rw-r--r--    * jg  staff     ** Mar ** **:** hello.rb
```

다음과 같이 파일을 인자로 줄 수도 있도록 하자.

```
./redact-number.rb /etc/krb5.conf
```

### 검열 필터 2

위와 동일하게 동작하되 홀수인 경우 `***` 로 짝수인 경우 `###` 형태로
마스킹하도록 수정해보자

```
$ echo 1 12 123 1234 | ./redact-number-2.rb
* ## *** ####
```

### wc

기본적으로 설치되어 있는 `wc` 를 루비로 구현해보자.

```sh
$ wc README.md make-hash.rb
    1381    4193   31682 README.md

$ wc README.md make-hash.rb
    1381    4193   31682 README.md
      19      31     255 make-hash.rb
    1400    4224   31937 total

$ cat README.md | wc
    1381    4193   31682
```

- 라인의 개수, 단어의 개수, 바이트 크기를 8 컬럼 단위로 우측
  정렬해 보인다.
- 단어의 개수는 `String#split` 으로 나눈 개수를 기준으로 한다.
- 파일이 여러개 있을 때는 `total` 을 추가적으로 표시한다.
- 파일이 주어졌을 때와 STDIN 을 읽을 때 동작이 다르므로 `Kernel#gets`
  로 모두 처리하기는 어려울 것.
- 위의 예제에 나온 것 이외의 기능은 구현하지 않아도 된다.
- `rubocop` 을 만족시켜라.

### 파일 통계

지정된 경로 하위의 파일들을 검색해서, 확장자 별 통계를 내는 프로그램을
구현해보자.

```sh
$ ./file-stat.rb ~/my-project1 ~/my-project2

[]
- count: ...
- sum(size): ...
- max(size): ...
- min(size): ...
- avg(size): ...

[.java]
- count: ...
- sum(size): ...
- max(size): ...
- min(size): ...
- avg(size): ...

[.xml]
- count: ...
- sum(size): ...
- max(size): ...
- min(size): ...
- avg(size): ...

...
```

### JSON API 사용

Chronos REST API 를 이용해 등록된 작업들의 이름을 최신실행순 (`lastSuccess`)
으로 상위 열개만 출력하는 프로그램을 만들어보자.

http://xxx.xxx.xxx.xxx/v1/scheduler/jobs

```sh
$ ./chronos-recent-10.rb
cm-checker-infra-hadoop-cm2: 2017-04-03T07:58:14.820Z
cm-checker-hbase-mdcm: 2017-04-03T07:58:14.013Z
cm-checker-cobalt011: 2017-04-03T07:58:13.794Z
cm-checker-hbase-mdcm2: 2017-04-03T07:58:13.500Z
cm-checker-tiger219: 2017-04-03T07:58:13.126Z
cm-checker-silver201: 2017-04-03T07:58:13.117Z
cm-checker-maroon001: 2017-04-03T07:58:13.012Z
cm-checker-dubai011: 2017-04-03T07:58:12.891Z
cm-checker-khaki010: 2017-04-03T07:58:12.807Z
cm-checker-hawk002: 2017-04-03T07:58:12.734Z
```

### 로그 분석

아래 링크의 로그는 Tenth map50 클러스터 블락 유실 시의 fsck 의 출력물이다.

http://xxx.xxx.xxx.xxx/ruby-study/fsck.output

위의 파일을 읽어 missing 블락이 포함된 HBase 데이터 파일을 찾고
(`/hbase/data/default/테이블명/...`) 파일을 구성하는 각 블락 (e.g.
`blk_1094156552`) 이 어떤 HBase 테이블에 속하는지 출력하는 스크립트를 만들자.
다음과 같은 형태로 출력하면 된다 (블락명, 소속테이블, 데이터사이즈, missing
여부).

```sh
blk_1094154198 PMAP 126155862 MISSING
blk_1094146495 FCHK 134217728
blk_1094146539 FCHK 134217728
blk_1094146585 FCHK 134217728 MISSING
```

참고
----

- https://learnrubythehardway.org/book/
- https://github.com/dalzony/ruby-style-guide/blob/master/README-koKR.md
- https://gist.github.com/nacyot/7624036

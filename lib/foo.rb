# = Foo
#
# Minitest 예제를 위한 클래스로
#
# * 이런
# * 저런
#
# 일을 합니다.
#
# == 사용방법
#
# [Foo#name] 이름을 리턴
# [Foo.bar_or_baz] 랜덤하게 +bar+ 혹은 +baz+ 를 리턴
#
# === 예제
#
#   # 클래스 메소드
#   # (들여쓰기를 하면 코드 블락이 됩니다)
#   Foo.bar_or_baz
#
#   # 인스턴스 메소드
#   foo = Foo.new
#   foo.name
#
class Foo
  # 이름을 리턴
  def name
    'foo'
  end

  # 랜덤하게 +bar+ 혹은 +baz+ 를 리턴한다.
  #
  # :call-seq:
  #   Foo.bar_or_baz() -> string
  #   Foo.bar_or_baz(no_need) -> string
  #
  def self.bar_or_baz(*_)
    rand(2).zero? ? 'bar' : 'baz'
  end
end

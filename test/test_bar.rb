require 'minitest/autorun'
require_relative '../lib/foo'

class TestBar < Minitest::Test
  def setup
    @foo = Foo.new
  end

  def test_that_foo_returns_foo
    assert_equal 'foo', @foo.name
  end

  def test_bar_or_baz
    assert_match /bar|baz/, Foo.bar_or_baz
  end

  def test_that_will_be_skipped
    skip 'test this later'
  end
end

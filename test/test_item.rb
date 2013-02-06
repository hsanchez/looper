# coding: utf-8

require 'helper'

class TestItem < Test::Unit::TestCase

  def setup
    @item = Looper::Item.new('huascar','https://huascarsanchez.com')
  end

  def test_name
    assert_equal 'huascar', @item.name
  end

  def test_value
    assert_equal 'https://huascarsanchez.com', @item.value
  end

  def test_short_name
    assert_equal 'huascar', @item.short_name
  end

  def test_spacer_none
    @item.name = 'huascar hsanchez h.a.sanchez ok too much'
    assert_equal '', @item.spacer
  end

  def test_spacer_tons
    assert_equal "         ", @item.spacer
  end

  def test_to_hash
    assert_equal 1, @item.to_hash.size
  end

  def test_url
    assert_equal 'https://huascarsanchez.com', @item.url
  end

end
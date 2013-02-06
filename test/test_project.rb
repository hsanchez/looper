# coding: utf-8

require 'helper'

class TestList < Test::Unit::TestCase

  def setup
    @list = Looper::Project.new('urls')
    @item = Looper::Item.new('huascar','https://huascarsanchez.com')
    looper_json :urls
  end

  def test_name
    assert_equal 'urls', @list.name
  end

  def test_add_items
    assert_equal 0, @list.items.size
    @list.add_item(@item)
    assert_equal 1, @list.items.size
  end


  def test_to_hash
    assert_equal 0, @list.to_hash[@list.name].size
    @list.add_item(@item)
    assert_equal 1, @list.to_hash[@list.name].size
  end

  def test_find
    assert_equal 'urls', Looper::Project.find('urls').name
  end

  def test_find_item
    @list.add_item(@item)
    assert_equal 'https://huascarsanchez.com', @list.find_item('huascar').value
  end

  def test_delete_success
    assert_equal 1, Looper.storage.lists.size
    assert Looper::Project.delete('urls')
    assert_equal 0, Looper.storage.lists.size
  end

  def test_delete_fail
    assert_equal 1, Looper.storage.lists.size
    assert !Looper::Project.delete('plastilinamosh')
    assert_equal 1, Looper.storage.lists.size
  end

end
# coding: utf-8

require 'helper'

class TestConfig < Test::Unit::TestCase

  def setup
    Looper::Config.any_instance.stubs(:file).
        returns("test/examples/test_json.json")

    @config = Looper::Config.new
    @config.stubs(:save).returns(true)
  end

  def test_config_bootstrap
    @config.bootstrap
    assert_equal ({:backend => 'json'}), @config.attributes
  end

  def test_attributes
    @config.attributes = { :lyoto => "machida" }
    assert_equal "machida", @config.attributes[:lyoto]
  end

end
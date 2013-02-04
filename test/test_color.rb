require 'helper'

class TestColor < Test::Unit::TestCase

  def test_colorize
    assert_equal "\e[35mBoom!\e[0m",
      Looper::Color.colorize("Boom!", :magenta)
  end

  def test_magenta
    assert_equal "\e[35mMagenta!\e[0m",
      Looper::Color.magenta("Magenta!")
  end

  def test_red
    assert_equal "\e[31mRed!\e[0m",
      Looper::Color.red("Red!")
  end

  def test_yellow
    assert_equal "\e[33mYellow!\e[0m",
      Looper::Color.yellow("Yellow!")
  end

  def test_cyan
    assert_equal "\e[36mCyan!\e[0m",
      Looper::Color.cyan("Cyan!")
  end

end
# coding: utf-8

begin
  require 'rubygems'
rescue LoadError
  # Oh well, we tried.
end

require 'fileutils'
require 'multi_json'
require 'cast'
require 'find'

$:.unshift File.join(File.dirname(__FILE__), *%w[.. lib])

require 'looper/color'
require 'looper/platform'
require 'looper/command'
require 'looper/config'
require 'looper/item'
require 'looper/list'

require 'looper/storage'
require 'looper/storage/base'
require 'looper/storage/json'



require 'looper/extensions/symbol'

module Looper
  VERSION = '0.0.1'

  extend self

  def storage
    @storage ||= Looper::Storage.backend
  end

  def config
    @config ||= Looper::Config.new
  end

end
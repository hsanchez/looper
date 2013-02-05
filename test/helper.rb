# coding: utf-8

require 'test/unit'

begin
  require 'rubygems'
  require 'redgreen'
rescue LoadError
  # Oops! We tried.
end

require 'mocha/setup'

$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

require 'looper'

def looper_json(name)
  root = File.expand_path(File.dirname(__FILE__))
  Looper::Storage::Json.any_instance.stubs(:save).returns(true)
  Looper::Storage::Json.any_instance.stubs(:json_file).
    returns("#{root}/examples/#{name}.json")
  Looper.stubs(:storage).returns(Looper::Storage::Json.new)
end
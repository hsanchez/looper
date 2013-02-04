# coding: utf-8

#
# Config manages all the config information for looper and its backends. It's a
# simple JSON Hash that gets persisted to `~/.looper` on-disk. You may access it
# as a Hash:
#
#     config.attributes = { :backend => "JSON" }
#     config.attributes[:backend]
#     # => "json"
#
#     config.attributes[:backend] = "Redis"
#     config.attributes[:backend]
#     # => "redis"
#

module Looper
  class Config
    # The main config file for looper
    FILE = "#{ENV['HOME']}/.looper.conf"

    # Public: The attributes Hash for configuration options. The attributes
    # needed are dictated by each backend, but the `backend` option must be
    # present.
    attr_reader :attributes

    def initialize
      bootstrap unless File.exist?(file)

    end

    # Public: accessor for the configuration file.
    #
    # Returns the String file path
    def file
      FILE
    end

    # Public: saves an empty, barebones hash to @attributes for the purpose of
    # new user setup.
    # Returns whether the attributes were saved.
    def bootstrap
      @attributes = {
          :backend => 'json'
      }

      save

    end

    # Public: assigns a hash to the configuration attributes object. The
    # contents of the attributes hash depends on what the backend needs. A
    # `backend` key MUST be present, however.
    #
    # attrs - the Hash representation of attributes to persist to disk.
    #
    # Examples
    #
    #     config.attributes = {"backend" => "json"}
    #
    # Returns whether the attributes were saved.
    def attributes=(attrs)
      @attributes = attrs
      save
    end

    # Public: loads and parses the JSON tree from disk into memory and stores
    # it in the attributes Hash.
    #
    # Returns nothing.
    def load_attributes
      @attributes = MultiJson.decode(File.new(file, 'r').read)
    end

    # Public: writes the in-memory JSON Hash to disk.
    #
    # Returns nothing.
    def save
      json = MultiJson.encode(attributes)
      File.open(file, 'w') { |f| f.write(json) }
    end

  end
end

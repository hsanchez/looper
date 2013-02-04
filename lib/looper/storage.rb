# coding: utf-8

#
# Storage is the interface between multiple Backends. You can use
# Storage directly without having to worry about which Backend is
# in use.
#
module Looper
  module Storage

    def self.backend=(backend)
      backend = backend.capitalize
      Looper::Storage.const_get(backend)
      Looper.config.attributes['backend'] = backend.downcase
      Looper.config.save
    end

    def self.backend
      Looper::Storage.const_get(
          Storage.config.attributes['backend'].capitalize
      ).new
    end
  end
end
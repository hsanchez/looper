# coding: utf-8

# The representation of the base unit in looper. An Item contains just a name and
# a value. It doesn't know its parent relationship explicitly; the parent Project
# object instead knows which Items it contains.
#
module Looper
  class Item

    # Public: the String name of the Item
    attr_accessor :name

    # Public: the String value of the Item
    attr_accessor :value

    # Public: creates a new Item object.
    #
    # name  - the String name of the Item
    # value - the String value of the Item
    #
    # Examples
    #
    #   Item.new("ucsc", "http://www.ucsc.edu")
    #
    # Returns the newly initialized Item.
    def initialize(name,value)
      @name  = name
      @value = value
    end

    # Public: the shortened String name of the Item. Truncates with ellipses if
    # larger.
    #
    # Examples
    #
    #   item = Item.new("ucsc's home page","http://www.ucsc.edu")
    #   item.short_name
    #   # => 'ucsc's home p...'
    #
    #   item = Item.new("ucsc","http://www.ucsc.com")
    #   item.short_name
    #   # => 'ucsc'
    #
    # Returns the shortened name.
    def short_name
      name.length > 15 ? "#{name[0..14]}..." : name[0..14]
    end

    # Public: the amount of consistent spaces to pad based on Item#short_name.
    #
    # Returns a String of spaces.
    def spacer
      name.length > 15 ? '' : ' '*(15-name.length+1)
    end

    # Public: only return url part of value - if no url has been
    # detected returns value.
    #
    # Returns a String which preferably is a URL.
    def url
      @url ||= value.split(/\s+/).detect { |v| v =~ %r{\A[a-z0-9]+:\S+}i } || value
    end

    # Public: creates a Hash for this Item.
    #
    # Returns a Hash of its data.
    def to_hash
      { @name => @value }
    end

  end
end
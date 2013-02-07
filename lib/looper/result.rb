module Looper
  class Result
    # Public: lets you access the array of items contained within this Project.
    #
    # Returns an Array of Items.
    attr_accessor :stuff
    # Public: the name of the Project.
    #
    # Returns the String name.
    attr_accessor :name

    def initialize(name)
      @stuff = []
      @name  = name
    end

    def add_stuff(item)
      delete_stuff(item.name) if find_stuff(item.name)
      @stuff << item
    end

    def delete_stuff(name)
      previous = stuff.size
      stuff.reject! { |item| item.name == name }
      previous != items.size
    end

    def find_stuff(name)
      stuff.find do |item|
        item.name == name
      end
    end

    # Public: a Hash representation of this list.
    #
    # Returns a Hash of its own data and its child items.
    def to_hash
      { name => stuff.collect(&:to_hash) }
    end
  end
end
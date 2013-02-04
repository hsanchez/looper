# The List contains many Items. They exist as buckets in which to categorize
# individual Items. The relationship is maintained in a simple array on the
# List-level.
#
module Looper
  class List
    def initialize(name)
      @items = []
      @name  = name
    end

    # Public: accesses the in-memory JSON representation.
    #
    # Returns a Storage instance.
    def self.storage
      Looper.storage
    end

    # Public: lets you access the array of items contained within this List.
    #
    # Returns an Array of Items.
    attr_accessor :items
    # Public: the name of the List.
    #
    # Returns the String name.
    attr_accessor :name

    # Public: associates an Item with this List.  If the item name is already
    # defined, then the value will be replaced
    #
    # item - the Item object to associate with this List.
    #
    # Returns the current set of items.
    def add_item(item)
      delete_item(item.name) if find_item(item.name)
      @items << item
    end

    # Public: finds any given List by name.
    #
    # name - String name of the list to search for
    #
    # Returns the first instance of List that it finds.
    def self.find(name)
      storage.lists.find { |list| list.name == name }
    end

    # Public: deletes a list by name
    #
    # name - String name of the list to delete
    #
    # Returns whether one or more lists where removed.
    def delete(name)
      previous = storage.lists.size
      storage.lists = storage.lists.reject { |list| list.name == name }
      previous != storage.lists.size
    end

    # Public: finds an item by name. If the name is typically truncated, also
    # allow a search based on that truncated name.
    #
    # name - String name of item was removed.
    #
    # Returns whether an item was removed.
    def delete_item(name)
      previous = items.size
      items.reject! { |item| item.name == name }
      previous != items.size
    end

    # Public: finds an item by name. If the name is typically truncated, also
    # allow a search based on that truncated name.
    #
    # name - String name of the item to find.
    #
    # Returns the found item
    def find_item(name)
      items.find do |item|
        item.name == name ||
        item.short_name.gsub('...', '') == name.gsub('...', '')
      end
    end

    # Public: a Hash representation of this list.
    #
    # Returns a Hash of its own data and its child items.
    def to_hash
      { name => items.collect(&:to_hash) }
    end

  end
end
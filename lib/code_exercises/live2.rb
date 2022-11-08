require 'pry-byebug'

class Cache
  attr_accessor :cache #to remove if production code

  def initialize(max_size)
    @max_size = max_size
    @cache = {}
    @order = []
  end

  def update_order(key)
    i = @order.find_index(key)
    @order.delete_at(i)
    @order.push(key)
  end

  def read(key)
    update_order(key) if @cache[key]
    return @cache[key]
  end

  def write(key, val)
    if num_records >= @max_size
      least_used = @order.shift
      delete(least_used)
    end
    @order.push(key) unless @cache[key]
    @cache[key] = val
  end

  def delete(key)
    @cache.delete(key)
  end

  def clear
    @cache = {}
    @order = []
  end

  def num_records
    @cache.keys.length
  end
end

c = Cache.new(50)
puts c
puts c.read("key1")
puts c.write("key1", "val1")

class Node
  @left
  @right
  @self
end
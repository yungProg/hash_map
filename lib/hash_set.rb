# frozen_string_literal: true

# Object representing a `HashSet`
class HashSet
  def initialize
    @load_factor = 0.75
    @capacity = 16
    @size = 0
    @threshold = @load_factor * @capacity
    @buckets = Array.new(@capacity) { [] }
  end

  def hash(key)
    hash_code = 0
    prime_number = 31
    key.each_char { |char| hash_code = (prime_number * hash_code) + char.ord}

    hash_code % @capacity
  end

  def bucket_index(key)
    index = hash(key)
    raise IndexError if index.negative? || index >= @buckets.length
    index
  end

  def grow
    active_buckets = keys
    @size = 0
    @capacity *= 2
    @threshold = @load_factor * @capacity
    @buckets = Array.new(@capacity) { [] }
    active_buckets.each { |item| set(item)}
  end

  def shrink
    return if @capacity <= 16
    active_buckets = keys
    @size = 0
    @capacity /= 2
    @threshold = @load_factor * @capacity
    @buckets = Array.new(@capacity) { [] }
    active_buckets.each { |item| set(item) }
  end

  def set(key)
    bucket = bucket_index(key)
    @buckets[bucket].each do |item|
      return if item == key
    end
    @buckets[bucket] << key
    @size += 1
  end

  def has?(key)
    bucket = bucket_index(key)
    @buckets[bucket].include?(key)
  end

  def remove(key)
    bucket = bucket_index(key)
    deleted = @buckets[bucket].delete(key)
    @size -= 1
    shrink if @size < (@capacity * 0.25) && @capacity > 16
    deleted
  end

  def length
    @size
  end

  def clear
    @capacity = 16
    @size = 0
    @threshold = @load_factor * @capacity
    @buckets = Array.new(@capacity) { [] }
  end

  def keys
    @buckets.flatten.map(&:itself)
  end

  private :bucket_index, :shrink, :grow
end
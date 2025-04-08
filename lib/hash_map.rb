# frozen_string_literal: true

# Object representing a `HashMap`
class HashMap
  def initialize
    @load_factor = 0.75
    @capacity = 16
    @threshold = @load_factor * @capacity
    @buckets = Array.new(@capacity) { [] }
    @size = 0
  end

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = (prime_number * hash_code) + char.ord }

    hash_code % @capacity
  end

  def bucket_index(key)
    index = hash(key)
    raise IndexError if index.negative? || index >= @buckets.length
    index
  end

  def grow
    active_buckets = entries
    @capacity *= 2
    @threshold = @capacity * @load_factor
    @size = 0
    @buckets = Array.new(@capacity) { [] }
    active_buckets.each { |key, value| set(key, value) }
  end

  def shrink
    return if @capacity <= 16
    active_buckets = entries
    @capacity /= 2
    @threshold = @capacity * @load_factor
    @size = 0
    @buckets = Array.new(@capacity) {Array.new}
    active_buckets.each { |key, value| set(key, value) }
  end

  def set(key, value)
    grow if length >= @threshold
    bucket = bucket_index(key)
    @buckets[bucket].each do |pair|
      if key == pair[0]
        pair[1] = value
        return
      end
    end
    @buckets[bucket] << [key, value]
    @size += 1
  end

  def get(key)
    bucket = bucket_index(key)
    @buckets[bucket].each { |pair| return pair[1] if key == pair[0] }

    nil
  end

  def has?(key)
    bucket = bucket_index(key)
    @buckets[bucket].any? { |pair| key == pair[0] }
  end

  def remove(key)
    bucket = bucket_index(key)
    deleted_pair = nil
    @buckets[bucket].each do |pair|
      if pair[0] == key
        deleted_pair = @buckets[bucket].delete(pair)
        @size -= 1
        break
      end
    end
    shrink if @size < (@capacity * 0.25) && @capacity > 16
    deleted_pair
  end

  def length
    @size
  end

  def clear
    @capacity = 16
    @threshold = @capacity * @load_factor
    @buckets = Array.new(@capacity) { [] }
    @size = 0
  end

  def keys
    @buckets.flat_map { |bucket| bucket.map(&:first) }
  end

  def values
    @buckets.flat_map { |bucket| bucket.map(&:last) }
  end

  def entries
    @buckets.flat_map { |bucket| bucket.map(&:itself)}
  end

  private :grow, :shrink, :bucket_index
end

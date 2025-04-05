# frozen_string_literal: true

# Object representing a `HashMap`
class HashMap
  def initialize
    @load_factor = 0.8
    @capacity = 16
    @threshold = @load_factor * @capacity
    @buckets = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []]
  end

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = (prime_number * hash_code) + char.ord }

    hash_code
  end

  def set(key, value)
    bucket = hash(key) % @capacity
    return @buckets[bucket] << [key, value] if @buckets[bucket].empty?

    @buckets[bucket].each_with_index do |pair, index|
      return pair[1] = value if key == pair[0]
    end
    
    @buckets[bucket] << [key, value] 

  end

  def get(key)
    bucket = hash(key) % @capacity
    @buckets[bucket].each {|pair| return pair[1] if key == pair[0]}

    nil
  end

  def has?(key)
    bucket = hash(key) % @capacity
    @buckets[bucket].any? {|pair| key == pair[0]}
  end

  def remove(key)
    bucket = hash(key) % @capacity
    deleted_pair = nil
    @buckets[bucket].each do |pair|
      if key == pair[0]
        deleted_pair = @buckets[bucket].delete(pair)
        break
      end
    end
    deleted_pair
  end

  def length
    buckets_dup = @buckets.dup.flatten
    counter = 0
    buckets_dup.each {counter += 1}
    counter / 2
  end
end
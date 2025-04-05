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

      return @buckets[bucket] << [key, value] if @buckets[bucket].length == index + 1
    end
  end
end

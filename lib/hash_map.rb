class HashMap
  attr_accessor :load_factor, :capacity
  
  def initialize
    @load_factor = 0.8
    @capacity = 16
  end

  def hash(key)
    hash_code = 0
    prime_number = 31

    key.each_char { |char| hash_code = prime_number * hash_code + char.ord }

    hash_code
  end
end
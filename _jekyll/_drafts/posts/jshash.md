class JSHash
  def initialize(hash)
    @original_hash = hash
    @hash = build_recursively(hash)
  end

  def method_missing(m, *args, &block)
    response = @hash.send(:[], m.to_s, *args, &block)
    return response if response
    response = @hash.send(:[], m.to_sym, *args, &block)
    return response if response
    raise NoMethodError
  end

  def [](arg)
    @hash[arg]
  end

  def to_s
    @original_hash.to_s
  end

  private

  def build_recursively(hash)
    hash.each_with_object({}) do |(k, v), hash|
      new_value =
        if v.is_a?(Hash)
          JSHash.new(v)
        else
          v
        end
      hash.merge!(k => new_value)
    end
  end
end

require_relative 'j_s_hash'

hash = {
  pedro: 'gomez',
  roberto: {
    hola: 123,
    chau: 456
  },
  'alejandro' => {
    asd: 1,
    'sad' => 2,
    otro: {
      'otro_mas' => {
        'asd' => 123
      }
    }
  },
  'carlos' => 789,
  1 => 2
}

jshash = JSHash.new(hash)

puts jshash.pedro
puts jshash.roberto
puts jshash.roberto.hola
puts jshash.roberto.chau
puts jshash.alejandro
puts jshash.alejandro.asd
puts jshash.alejandro.sad
puts jshash.carlos
puts jshash.alejandro.otro.otro_mas.asd
puts jshash[1]

# This prints:
#
# gomez
# {:hola=>123, :chau=>456}
# 123
# 456
# {:asd=>1, "sad"=>2, :otro=>{"otro_mas"=>{"asd"=>123}}}
# 1
# 2
# 789
# 123
# 2

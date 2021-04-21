class Result
  def initialize(options = {})
    @success = options[:success] || false
    @error = options[:error]
    @result = options[:result]
  end

  def success?
    @success
  end
end

module SymbolExtensions
  def ===(other)
    if other.is_a?(Result)
      if other.success?
        return true if self == :ok
      else
        return true if self == :error
      end
      false
    else
      super
    end
  end
end

class Symbol
  prepend SymbolExtensions
end

successful = Result.new(success: true)
wrong = Result.new(success: false)

res = wrong

case res
when :ok
  puts "Everything worked fine"
when :error
  puts "There was an error"
end

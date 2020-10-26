retryable https://gist.github.com/alebian/1bd980b683987846b9301e8619a81f55
chainable objects https://gist.github.com/alebian/2b04ef58750eef627aa16d1f4a96f74c
gracefully https://gist.github.com/alebian/0b5c4432f7f8dcff00309870f0c2c9b8
rspec matcher https://gist.github.com/alebian/14d9ff254caab6b3e2de7200e4e767ae
database row stream https://gist.github.com/alebian/aa2b1f926243e178f6ce72b60f172741
configuration class https://gist.github.com/alebian/3981c84d4060ce3b322646e460343d1d
crear gema
firuta
create a console
error handling with switch
irbc
commands
benchmark https://gist.github.com/alebian/724144c98f269d3f0407986f0a8be949
model to csv https://gist.github.com/alebian/128625193188a4017f1fa1b4ed68093f
cache files https://github.com/alebian/tips-tricks/blob/master/ruby.md#cache-file-contents
core extensions https://github.com/alebian/tips-tricks/blob/master/ruby.md#core-extensions
hash with empty values https://github.com/alebian/tips-tricks/blob/master/ruby.md#create-hash-with-empty-or-not-values
deep dup https://github.com/alebian/tips-tricks/blob/master/ruby.md#deep-dup
map with args https://github.com/alebian/tips-tricks/blob/master/ruby.md#pass-arguments-to-the-shorthand-way-of-calling-map

configurable https://gist.github.com/alebian/3981c84d4060ce3b322646e460343d1d
spy https://gist.github.com/alebian/b8a2350803ee3471b4ebd5b05abb2fca
biruda
struct https://gist.github.com/alebian/0cff0ca5a97d4de61430a5c04a083d3c
delegator https://gist.github.com/alebian/002895b01cb458f8fac63d56358eb4d3
js hash https://gist.github.com/alebian/f56154d69757fad1fcad5d5c59a726f1


|   |
|---|
|   |
|   |
|   |
|   |
|   |

In this series I'll try to show you tips and tricks of the Ruby language that, hopefully, you can use to improve your code. Some of them are better known than others, and some require a more advance knowledge of Ruby since they use metaprogramming, but I'll try use them in a way you might find useful in your projets.



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

class Chain
  def then(&block)

  end

  def catch(&block)

  end
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

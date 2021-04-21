## Retry keyword

There is one keyword that not many Ruby programmers know, `retry`. As it's name suggests, it let's you retry a piece of code in case an exception is thrown or some condition is not met.

class Retryer
  def initialize
    @retry_times = 3
    @block = Proc.new {}
    @args = nil
    @backoff = false
  end

  def block(&block)
    @block = block
    self
  end

  def args(*args)
    @args = args
    self
  end

  def times(times)
    @retry_times = times
    self
  end

  def with_backoff
    @backoff = true
    self
  end

  def execute(*args)
    @tries = 0

    begin
      sleep ((2 ** @tries) - 1) / 2 if @backoff

      @tries += 1
      puts "Try ##{@tries}"

      if @args.nil?
        @block.call(*args)
      else
        @block.call(*@args)
      end

    rescue Exception => e
      retry if @tries < @retry_times
      puts e
    end
  end
end

retryer = Retryer.new
                 .times(4)
                 .block { |a1, b1| puts a1 + b1 }
                 .args(1, 2)
                 .with_backoff

retryer.execute # Normal result

retryer.args(1).execute # Retries because nil can't be coerced into Integer

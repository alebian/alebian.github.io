class DatabaseStream
  include Enumerable

  DEFAULT_BATCH_SIZE = 1000

  def initialize(sql, options = {})
    @sql = sql
    if options[:pluck]
      @pluck = options[:pluck].respond_to?(:join) ? options[:pluck].join(', ') : options[:pluck]
    end
    @batch_size = options[:batch_size] || DEFAULT_BATCH_SIZE
    reset_cursors!
  end

  def each
    while (row = read_from_buffer_or_fetch)
      yield row
    end
    reset_cursors!
  end

  private

  def reset_cursors!
    @gobal_cursor = 0
    @buffer_cursor = @batch_size
    @buffer = []
  end

  def read_from_buffer_or_fetch
    fetch_data if @buffer_cursor == @batch_size

    line = @buffer[@buffer_cursor]
    return nil unless line

    @gobal_cursor += 1
    @buffer_cursor += 1
    line
  end

  def fetch_data
    @buffer = @sql.limit(@batch_size).offset(@gobal_cursor)
    @buffer_cursor = 0
    @buffer = @pluck.present? ? @buffer.pluck(@pluck) :@buffer.select('*')
  end
end

class S3ObjectStream
  include Enumerable

  KILOBYTE = 1024
  MEGABYTE = 1024 * KILOBYTE

  def initialize(object, separator: "\n", iteration: MEGABYTE, bucket: nil)
    @object = object.is_a?(Aws::S3::Object) ? object : build_s3_object(object, bucket: bucket)
    @content_length = @object.content_length
    @separator = separator
    reset_cursors!
  end

  def each
    while (line = next_line)
      yield line
    end
    reset_cursors!
  end

  alias each_line each

  private

  def reset_cursors!
    @current = 0
    @iteration = iteration
    @buffer = ''
  end

  def build_s3_object(file_name, bucket:)
    Aws::S3::Resource.new.bucket(bucket).object(file_name)
  end

  def next_line
    loop do
      line = read_from_buffer_or_fetch
      return line if line.present?
    end
  rescue Aws::S3::Errors::InvalidRange => _e
    final_line = @buffer
    @buffer = nil
    final_line
  end

  def read_from_buffer_or_fetch
    idx = @buffer&.index(@separator)
    if idx.present?
      line = @buffer[0..(idx - 1)]
      @buffer = @buffer[(idx + 1)..-1]
      line
    else
      @buffer += @object.get(range: build_range).body.read
      nil
    end
  end

  def build_range
    range_init = @current
    range_final = @current + @iteration - 1
    @current = range_final > @content_length ? @content_length : (range_final + 1)
    "bytes=#{range_init}-#{range_final}"
  end
end

---
title: Memory efficient file streaming from AWS S3
published: true
description: Stream files from AWS S3 without downloading them completely
tags: ruby, rails, aws, streams, s3
layout: post_with_donation
date: 2020-12-03 00:00:00 -0300
categories: ruby rails aws streams s3
---

In my [previous post](https://blog.alebian.com/ruby/rails/sql/2020/11/24/re-wheel-1-how-does-rails-find_each-work.html) I talked about how you could efficiently stream database rows for processing. This time I want to talk about how you can implement the same to process lines in a file. I am going to use the same principles here, so I recommend you to read that post.

If you have to process large files, you don't want to load them completely in memory because you can run out of memory. Knowing how to efficiently read a file is an essential skill in any programming language and even though I am going to show you code in Ruby, I hope you can transfer the ideas of this post into your favourite programming language.

[This post](https://blog.appsignal.com/2018/07/10/ruby-magic-slurping-and-streaming-files.html) already covers very well the subject of file streaming in Ruby, so, in order to make it more interesting I am going to show you how you can stream a file stored in AWS S3 line by line without downloading it completely. Of course, for most cases, it's probably a better idea to download the whole file and then process it, but let's assume that there is a limit on the amount of disk you can use, or that you don't want to wait until the whole file is downloaded to process it.

The title of the post lies a little bit, because we are going to download the file, but the idea is to download small pieces of it and discard them after processing. So the first thing we should know is how to download a piece of file from S3, fortunately we can do that using URI parameters according to [their documentation](https://docs.aws.amazon.com/AmazonS3/latest/API/API_GetObject.html). I will not make the requests by hand, instead I'll use the official [S3 gem](https://github.com/aws/aws-sdk-ruby/tree/master/gems/aws-sdk-s3). The AWS documentation specifies that the range of the file must respect the [RFC 2616](https://www.w3.org/Protocols/rfc2616/rfc2616-sec14.html#sec14.35) specification, so if we want to get the first 100 bytes of a file we have to do something like:

```ruby
require 'aws-sdk-s3'

def build_range(range_start, range_end)
  "bytes=#{range_start}-#{range_end}"
end

object = Aws::S3::Resource.new.bucket('some-bucket').object('some-file')
object.get(range: build_range(0, 100)).body.read
```

Great! With this we can have a buffer in memory that stores the downloaded bytes and work with that. Before going into the implementation, let's consider the possible situations we can run into and think what we should do:

1. We download a slice of the file that contains a new line character: we just return the first part of the buffer and keep the rest.
2. The downloaded bytes do not have a new line character: we have to keep downloading until we get a new line character or we reach the end of the file.
3. Reached the end of the file: we return the remaining bytes of the buffer.

Now that we have an idea of what to do I'll show you my implementation:

```ruby
class RemoteFileIterator
  include Enumerable

  KILOBYTE = 1024
  MEGABYTE = 1024 * KILOBYTE

  def initialize(file_name, new_line_character: "\n", batch_size: MEGABYTE, bucket:)
    @object = Aws::S3::Resource.new.bucket(bucket).object(file_name)
    @content_length = @object.content_length
    @new_line_character = new_line_character
    @batch_size = batch_size
    reset_cursors!
  end

  def each
    if block_given?
      while (line = read_buffer_or_fetch!)
        yield line
      end
      reset_cursors!
    else
      to_enum(:each)
    end
  end

  private

  def reset_cursors!
    @cursor = 0
    @buffer = nil
  end

  def read_buffer_or_fetch!
    if buffer_has_new_line_character?
      take_line_from_buffer!
    elsif @cursor < @content_length
      @buffer = (@buffer || '') + @object.get(range: build_range!).body.read
      read_buffer_or_fetch!
    end
  end

  def buffer_has_new_line_character?
    !buffers_new_line_character_idx.nil?
  end

  def buffers_new_line_character_idx
    @buffer&.index(@new_line_character)
  end

  def take_line_from_buffer!
    new_line_character_idx = buffers_new_line_character_idx
    line = @buffer[0..(new_line_character_idx - @new_line_character.size)]
    @buffer = @buffer[(new_line_character_idx + @new_line_character.size)..-1]
    @buffer = nil if @buffer.empty? # Doing str[str.size..-1] returns ''
    line
  end

  def build_range!
    range_start = @cursor
    range_end = @cursor + @batch_size - 1
    @cursor = range_end > @content_length ? @content_length : (range_end + 1)
    "bytes=#{range_start}-#{range_end}"
  end
end
```

As you can see it is very similar to the class in my previous post (I won't explain the Enumerable tricks in this post again). The `build_range!` method is pretty much the same as the one I showed you in the beginning of this post, but it also keeps track of the cursor.

In the `take_line_from_buffer!` method we first find the position of the first new line character and then we split the buffer in two parts, returning the first one and keeping the last one in the buffer.

The `read_buffer_or_fetch!` method recursively fetches data until we find a new line or we downloaded all the file. There is another way of writing this without checking if `cursor < content_length`:

```ruby
  def each
    ...
    while (line = next_line!)
      yield line
    end
    ...
  end

  def next_line!
    read_buffer_or_fetch
  rescue Aws::S3::Errors::InvalidRange => _e
    # Since we don't check if we ask for bytes outside the length
    # we can take advantage of the exception thrown by the AWS gem
    final_line = @buffer
    @buffer = nil
    final_line
  end

  def read_buffer_or_fetch
    if buffer_has_new_line_character?
      take_line_from_buffer!
    else # Removed the condition
      ...
    end
  end
```

Both implementations work but I prefer to avoid using exceptions for control flow because I consider that an anti-pattern.

As a final thougth, it's worth noting that if you use this implementation with a file that does not have a new line character you will end up downloading the whole file in memory (which is what we wanted to avoid). For those cases you should consider other techniques that are outside of the scope of this post.

### Conclusions

Even though this might not be a great idea for regular files (since it makes several requests to download), this might be useful in specific use cases, for example if you have no disk space (or very little) or if the files you have to work with are very large and the download takes too much time (or fails) while your processing workers are idle in the meantime.

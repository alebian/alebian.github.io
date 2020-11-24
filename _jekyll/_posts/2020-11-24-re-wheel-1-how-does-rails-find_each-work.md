---
title: Re-Wheel series part 1 - How does Rails' find_each work?
published: true
description: Understand the Rails' find_each method by rewriting it
tags: ruby, rails, streams, sql
layout: post_with_donation
date: 2020-11-24 00:00:00 -0300
categories: ruby rails sql
---

Over the years I found that in order to learn something I have to understand it. For software concepts, this means that sometimes I write code that has already been written, and probably much better. This is usually referred to "reinventing the wheel", which is something that I don't recommend when writing code professionally, but since it's a very good learning exercise I decided to create a series of posts in which I'll try to dissect some interesting and commonly used techniques to help you understand them and thus, learn.

For the first post of my Re-Wheel series I wanted to talk about ActiveRecord's [find_each](https://apidock.com/rails/ActiveRecord/Batches/find_each). This method lets you process database records in batches, which reduces the memory consumption of your app and increases the amount of queries you make (one for each batch). You have to think about memory consumption on every project (not only Rails ones), so you can port this idea to whatever language or framework you are using.

Let's say you have 1 million users and you want to print all their emails on the screen, you could do something like `User.all.each { |user| puts user.email }` but this will load all the records in memory (which is not good). The equivalent and memory efficient way to do it is: `User.all.find_each { |user| puts user.email }`.

But how is this implemented? Well, if you use pagination in your index methods with gems like [pagy](https://github.com/ddnexus/pagy), [kaminari](https://github.com/kaminari/kaminari) or [will_paginate](https://github.com/mislav/will_paginate) you will find that the same idea is happening here, they are using the power of [SQL's LIMIT and OFFSET](https://www.postgresql.org/docs/9.3/queries-limit.html) to fetch only a portion of the data each time. So in the 1 million users example, `find_each` will perform 1000 thousand queries with a limit of 1000 while changing the offset properly so we don't miss any record.

There is another cool thing about the `find_each` method. As you can see, it receives a block which is executed with each row, making use of the powerful Ruby's [enumerable](https://blog.appsignal.com/2018/05/29/ruby-magic-enumerable-and-enumerator.html) module.

There is a small limitation in this method, it doesn't work with the [pluck](https://apidock.com/rails/ActiveRecord/Calculations/pluck) method. Since we are doing this to reduce the memory footprint, selecting only the required columns from the table is a reasonable thing to do, so let's add that feature in our implementation.

I'll show you the code I wrote and then explain each part:

```ruby
class DatabaseStream
  include Enumerable

  DEFAULT_BATCH_SIZE = 1000

  def initialize(sql, options = {})
    @sql = sql
    @pluck = options[:pluck]
    @batch_size = options[:batch_size] || DEFAULT_BATCH_SIZE
    reset_cursors!
  end

  def each
    if block_given?
      while (row = read_from_buffer_or_fetch)
        yield row
      end
      reset_cursors!
    else
      to_enum(:each)
    end
  end

  private

  def reset_cursors!
    @gobal_cursor = 0
    @buffer_cursor = @batch_size
    @buffer = []
  end

  def read_from_buffer_or_fetch
    fetch_data if @buffer_cursor == @batch_size

    row = @buffer[@buffer_cursor]
    return nil unless row

    @gobal_cursor += 1
    @buffer_cursor += 1
    row
  end

  def fetch_data
    @buffer = @sql.limit(@batch_size).offset(@gobal_cursor)
    @buffer = @buffer.pluck(@pluck) if @pluck.present?
    @buffer_cursor = 0
  end
end
```

To test this code you can run:

```ruby
query = User.all
stream = DatabaseStream.new(query)
stream.each { |user| puts user.email }

stream = DatabaseStream.new(query, batch_size: 100, pluck: 'id, email') # pluck: %i[id, email] also works
stream.each { |user| puts user[1] } # pluck returns an array
```

The main idea is to have 2 pointers, one for the current element in the batch and one for the overall position (used for the offset). The `fetch_data` method performs the query setting the limit and offset and selecting the columns if the pluck parameter was given. The result is then stored inside a buffer in memory and sets the cursor to point the first element on it.

When creating the instance, I set `@buffer_cursor = @batch_size` and then in the `read_from_buffer_or_fetch` method I check for this condition before making the query. This allows me to lazy initialize the object, to perform the query only when it's really needed. There are other ways of achieving lazyness but I think this one makes the code look clean.

As you can see, I included the `Enumerable` module so I had to implement the `each` method which iterates over all the elements. In it, I made a few (non crucial) tricks:

* First I check if a block was given. If it was, I simply [yield](https://rubymonk.com/learning/books/4-ruby-primer-ascent/chapters/18-blocks/lessons/54-yield) the row to the block. But if the block is not given, and here is the trick, I call the [to_enum](https://apidock.com/ruby/Object/to_enum) method which creates a new enumerator from my method `each`. This last part is important because now I can chain my enumerator with others and do things like: `stream.each.with_index { |row, idx| puts idx }`.
* Reset the buffer and cursors to allow multiple iterations of the collection. Without this, if I want to iterate over the elements again I have to create a new object.

And that's all for this Re-Wheel part, I hope you can pick up a trick or two from this!

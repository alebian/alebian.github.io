---
title: Six degrees of Wikipedia
published: true
description: Find the degrees of separation between Wikipedia articles
tags: ruby, programming, graphs, bfs
layout: post
date: 2019-09-18 00:00:00 -0300
categories: ruby programming graphs bfs
---

A few years ago, I read an [interesting article](https://research.fb.com/blog/2016/02/three-and-a-half-degrees-of-separation/) about the degrees of separation between Facebook users. Regardless of the result in the article, I thought it would be exciting to find the separation between other things, like Wikipedia articles.

For this problem, we are going to receive 2 valid Wikipedia articles and return a minimum list of articles that connects the two given. Two articles are connected if there is a link in one of the articles to the other (the other way around is not needed).

Let's divide the problem into parts that we can solve separately:

* Get an article from wikipedia.
* Get all the links in an article to other articles.
* Find the minimum path between 2 articles.

For the first two, we need to fetch an article using HTTP and then, find all the `a` tags that reference other articles. Inspecting the HTML we can see that every article has links that we want to skip (like the main page and external links):

```ruby
module Services
  class Wikipedia
    BASE_URL = 'https://en.wikipedia.org'.freeze

    class << self
      def article_links(article)
        article = get_article(article)

        article.css('a').each_with_object([]) do |link, array|
          href = link['href']
          array << href if internal?(href) && !array.include?(href)
          array
        end
      end

      private

      def get_article(article)
        uri = URI.parse("#{BASE_URL}#{article}")
        Nokogiri::HTML(uri.read)
      end

      def internal?(link)
        link =~ /^\/wiki\/*/ && !link.include?(':') && link != '/wiki/Main_Page'
      end
    end
  end
end
```

I used the [Nokogiri](https://nokogiri.org/) gem to parse the HTML and easily search the `a` tags.

Playing with the code I found that it would be nice to have some sort of cache so we don't loose the data fetched from Wikipedia. I used Redis for this:

```ruby
module Repositories
  class Redis
    REDIS_URL = 'redis://localhost:6379'.freeze

    def initialize
      @connection = ::Redis.new(url: REDIS_URL)
    end

    def get_links(path)
      return Oj.load(@connection.get(path)) if @connection.exists(path)

      links = Services::Wikipedia.article_links(path)
      @connection.set(path, links.to_json)

      links
    end
  end
end
```

The last part of the task is the actual algorithm. In this case, we can think of the articles as nodes of a graph and the links as the vertices, forming a directed graph. Since accessing each node has the same cost (an HTTP request), we can pretend this is an unweighted graph or a weighted one with the same cost on every edge.

To build the graph I'll use a gem called [RGL](https://github.com/monora/rgl) and it also gives us a search algorithm so we don't have to implement one. Since we don't have the graph, we have to be smart about the way we create it. Traversing the links using DFS (depth-first search) may lead us to create a graph with an unnecesary amount of nodes, so I think it's better to use BFS (breadth-first search) to build it:

```ruby
module Crawlers
  class Graph < Base
    def call
      graph = RGL::DirectedAdjacencyGraph.new

      queue = []
      queue.push(@from_path)

      while (current = queue.shift) != nil
        links = @repository.get_links(current)

        links.each do |link|
          unless graph.has_vertex?(link)
            graph.add_edge(current, link)
            queue.push(link)
          end
        end

        if links.include?(@to_path)
          return graph.dijkstra_shortest_path(EdgeWeightHack.new, @from_path, @to_path)
        end
      end
    end

    class EdgeWeightHack
      # The dijkstra_shortest_path expects a hash
      def [](key)
        1
      end
    end
  end
end
```

As you can see I used a queue for adding the nodes in a BFS manner and skipped them if the graph already had the link. I found that the RGL gem didn't have a search algorithm for unweighted graphs but it did have Dijkstra's algorithm for weighted ones. It expected a hash with the edge values, but since every edge has the same value and I didn't want to use unnecesary extra memory, I hacked a class called `EdgeWeightHack` taking advantage of Ruby's duck typing.

Now let's see this in action! Let's find out how separated is `Chuck Norris` from `Computer programming`:

```ruby
################################################################
Chuck_Norris is 3 degrees separated from Computer_programming.
################################################################
/wiki/Chuck_Norris
/wiki/Republican_Party_(United_States)
/wiki/Internal_Revenue_Service
/wiki/Computer_programming
################################################################
```

The algorithm had to search 1113 links to find the answer, and we (programmers) are only 3 degrees separated from Chuck! Nice!

After having something working, I always try to see if I can improve it. I feel that making a BFS to add the nodes and then searching the path is making double work, because the BFS will find a minimum path in this case!

Since I don't want to search, every node I put in the graph has to know the path I used to get to it, so let's build this custom graph:

```ruby
module Crawlers
  class Custom < Base
    def call
      queue = []
      queue.push(Node.new(@from_path))

      answer = []

      while (current = queue.shift) != nil
        return current.complete_articles_path if current.article == @to_path

        links = @repository.get_links(current.article)

        if links.include?(@to_path)
          return (answer = current.complete_articles_path << @to_path)
        end

        links.each do |article|
          unless current.previous_articles.include?(article)
            queue.push(Node.new(article, current.complete_articles_path))
          end
        end
      end

      answer
    end

    class Node
      attr_reader :article, :previous_articles

      def initialize(article, previous_articles = [])
        @article = article
        @previous_articles = previous_articles
      end

      def complete_articles_path
        @previous_articles + [@article]
      end
    end
  end
end
```

Now it's time to benchmark both solutions and see which one is best:

```
Benchmarking 100 times

       user     system      total        real
Custom 63.772801   9.894999  73.667800 (249.561173)
Graph 197.834715  10.884686 208.719401 (378.234052)

Memory usage of Custom ---------------------------
        Total allocated: 155287889 bytes (2223856 objects)
        Total retained: 546 bytes (2 objects)
Memory usage of Graph ----------------------------
        Total allocated: 259432021 bytes (2015009 objects)
        Total retained: 97485111 bytes (517055 objects)
```

Wow! That's actually a very big improvement in both speed and memory!

## Conclusion

Even though the result of solving this problem is not very useful, I had a lot of fun doing it. I was able to use the algorithms I've learned in a more "realistic" way (compared with the exercises found in books).

I hope you enojoyed this as much as I did! You can check the full implementation [on my github account](https://github.com/alebian/six-degrees-of-wikipedia)!

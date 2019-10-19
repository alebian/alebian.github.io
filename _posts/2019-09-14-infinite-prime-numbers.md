---
title: Infinite list of prime numbers using Python generators
published: true
description: Improve your coding speed using your editor correctly
tags: python, generators, primes
layout: post
date: 2019-09-14 00:00:00 -0300
categories: python generators primes
---

Sometimes we want to create collections of elements that are very expensive to calculate. The first option is to create a list and wait until all the elements are calculated before we use it. Although this works, it is not very efficient. To make it a bit more efficient, modern languages provide a way to create custom iterators so each element is calculated only when needed (this is also called lazy initialization). Also, iterators allows us to create infinite collections!

Python has, in my opinion, one of the most succint and elegant ways to declare iterators: [generators](https://wiki.python.org/moin/Generators).

Without further ado, let's try to create an infinite list of prime numbers.

The first thing we need is a way to detect if a number is prime:

```python
from math import sqrt

def is_prime(n):
    if (n <= 1) or (n % 2 == 0):
        return False
    if (n == 2):
        return True

    i = 3
    while i <= sqrt(n):
        if n % i == 0:
            return False
        i = i + 2

    return True
```

Now, using our `is_prime` function we can do:

```python
def prime_generator():
    n = 1
    while True:
        n += 1
        if is_prime(n):
            yield n
```

And that's it! Just call the function and get elements from it:

```python
generator = prime_generator()

for i in range(10):
    print(next(generator))
```

Or create a list of the first N prime numbers:

```python
from itertools import islice

array = [x for x in islice(prime_generator(), 10)]
```

As you could see, the iterator definition is one of the shortest and simplest among all languages.

def is_prime(n) :
    if (n <= 1) :
        return False
    if (n == 2) :
        return True

    i = 2
    while(i * i <= n) :
        if n % i == 0:
            return False
        i = i + 2

    return True

def prime_generator():
    n = 1
    while True:
        n += 1
        if is_prime(n):
            yield n

generator = prime_generator()

for i in range(10):
    print(next(generator))

from itertools import islice

array = [x for x in islice(prime_generator(), 10)]

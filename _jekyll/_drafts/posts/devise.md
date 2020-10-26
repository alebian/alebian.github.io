---
title: Ruby on Rails authentication with Devise explained
published: true
description:
tags: ruby, rails, bcrypt, authentication, devise
layout: post_with_donation
date: 2020-04-17 00:00:00 -0300
categories: ruby rails bcrypt authentication devise security
---

If you develop Ruby on Rails applications like me, I'm pretty sure you have used or configured an authentication solution in your app using the [Devise gem](https://github.com/heartcombo/devise) (or it was in your project and you didn't even know it!).

Devise is probably the most popular authentication library for Rails applications and also one of the most downloaded gems in the Ruby ecosystem (at the time of this writing, it has over 72 million downloads on [rubygems](https://rubygems.org/gems/devise)).

If you are fairly new in the Ruby on Rails world, I'm pretty sure you think that this gem is a kind of magic. So, the idea of this post is to show you what is behind the curtain.

There are a lot of posts and videos that show you how to configure and use Devise, but I haven't seen so far any that explains both how it works and why it uses the things that it uses under the hood. Since security is a very important subject and something you MUST take good care of in your applications I decided to go a little bit deeper on that.

### Slow and salted hashes

I'm sure you are familiar with hashing functions like MD5, SHA-1 or SHA-256, but it's very likely that you have never heard of other ones like [bcrypt](https://en.wikipedia.org/wiki/Bcrypt) or [PBKDF2](https://en.wikipedia.org/wiki/PBKDF2).

Let's try to hash a string in the console using SHA-256 and bcrypt and see if we can spot any difference:

```bash
$> echo -n "test" | openssl dgst -sha256
9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08

$> htpasswd -bnB -C 10 "" test
:$2y$10$wufNdgQDPgpb5dBxZlxVDuGwaa206FEbefw5Yj4SqWf6KlYw/iEJG
```

At first sight we can see that the second hash has some non alphanumeric characters like "$" and "/", but nothing looks suspicious. What happens if we run them again?

```bash
$> echo -n "test" | openssl dgst -sha256
9f86d081884c7d659a2feaa0c55ad015a3bf4f1b2b0b822cd15d6c15b0f00a08

$> htpasswd -bnB -C 10 "" test
:$2y$10$Iccdu6FPckoryrQrHrJVfOZFCSaBKqeMqOUR4jVdNO5xYgDsAi0o6
```

Well, like we expected, the first hash remained the same, but the second one changes... What happens here is that a [salt](https://en.wikipedia.org/wiki/Salt_(cryptography)) is added to change the hash on purpose (for example [this post](https://dev.to/alvesjtiago/how-does-devise-keep-your-passwords-safe-54go) explains the bcrypt hashing function in more datail).

I don't want to enter in the specifics of bcrypt or SHA in this post because there are a lot of other sources that you can find about that, what I rather do in this post is try to explain the reasons **why**.

Let's try with an example. Imagine that an attacker somehow gets access to our users database and makes a copy of it in her computer. What it would be terrible (for obvious reasons) is that our table looks something like this:

| email           | password |
|-----------------|----------|
| bob@example.com | 12345678 |
| ...             | ...      |

But because we are very clever developers and we know that our users database might be stolen, we could use a hash function like SHA-256 to store our users password hashes:

| email           | password |
|-----------------|----------|
| bob@example.com | ef797c8118f02dfb649607dd5d3f8c7623048c9c063d532cc95c5ed7a898a64f |
| ...             | ...      |

We should be okay now, right? Well, not quite. Our attacker here can use a [rainbow table](https://en.wikipedia.org/wiki/Rainbow_table) attack on our data, and the reason why this attack would be successful in this example **is because we used SHA-256** which returns the same output for the same input (same would happen with MD5 or any other hashing function with the same characteristic). Our attacker could have her own pre computed password/hash table created from [previous attacks](https://haveibeenpwned.com/Passwords) and easily hack our users.

So that's why adding a salt is important, because with it, attackers would have to iterate over all our users passwords, take the salt and then iterate over their list of common passwords and re-compute the hash. Which increments the algorithmic complexity of the attack from `O(N)` to `O(N * M)` where N is the size of our table and M is the size of the attacker's common passwords list.

So, assuming that we use a secure random salt generation algorithm, we can transform our user's password like this: `salt | SHA-256(password + salt)` and be okay, right?

Well... If we go down the rabbit hole a little bit more, even though we have increased the time complexity of the algorithm required to crack the passwords, an attacker can take advantage of the fact that this is a very parallelizable problem and if she has sufficient processing power, we are still in a very high risk.

This is where bcrypt comes into play. This hashing function, like many others, is designed to help with the mentioned problem using a very simple idea: being slow. Sounds silly, right? But let's see why it's a very good idea: imagine for a moment that our users table has `1 million rows` and that our resourceful attacker has an outstanding number of computers to her disposal, let's say 10.000 of them, meaning that she can parallelize the problem making each computer crack `1.000.000 / 10.000 = 100` passwords. For each of the passwords she has to iterate over the common passwords list and calculate the hash and then compare if they are the same. Just to give numbers let's say that there are 100 thousand common passwords in her list, that would be `100 * 100.000 = 10.000.000` hashes to calculate.

In my computer, running `time echo -n "12345678" | openssl dgst -sha256` says that it took 0.004 seconds, for 10 million hashes that would be a bit more than 11 hours. Now, if I run `time htpasswd -bnB -C 10 "" test` it says that it took 0.057 seconds (one order of magnitude more) so it would take me approximately 6 days to calculate 10 million hashes. Finally, running `time htpasswd -bnB -C 15 "" test` takes 1.565 seconds which adds up to a total of 181 days for my computer to calculate 10 million hashes! The number we send as a parameter to the htpasswd program is used to tell bcrypt how slow we want it to take (higher is slower). For other algorithms that parameter is called `rounds`.

Let's finish this post here because there is a lot of information to process. The important thing to remember the next time you use a hash function in your program, is to think about **why** you want to use it. I'm not saying that SHA-256 is bad, what I'm saying is that using SHA-256 (or any other fast hashing algorithm) to store passwords in your database might not be as safe as using bcrypt or any other slow hashing function. Same thing happens if we use bcrypt to calculate the checksum of a file, it would make the process unnecessarily slow.

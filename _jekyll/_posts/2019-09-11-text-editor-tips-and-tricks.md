---
title: Text editor tips and tricks to boost your productivity
published: true
description: Improve your coding speed using your editor correctly
tags: editor, productivity, vscode, tools
layout: post_with_donation
date: 2019-09-11 00:00:00 -0300
categories: editor productivity vscode tools
---

Recently, I was peer programming at work and, whithout thinking, I started to use a few editor tricks I had learned a while ago. My co-worker was amazed with them and picked up a few. At first I thought it was no big deal, but a few days later I began to observe that there are a lot of people who don't know many of these tricks. Since the tools we use have a lot of functionalities to make us more productive, it's a shame that we spoil them. That's why I thought it would be a good opportunity to transfer this useful knowledge and help others improve their productivity.

## Building blocks

All the tricks I'll show you are a combination of small pieces that seem insignificant at first sight, but are very powerful when they are combined. At the end I will show you some examples that (hopefully) show how useful these tricks are.

The examples were created using VS Code on a mac, but all these functionalities should be available in every editor and IDE.

### Moving cursor

Let's start slowly but surely.

Use the arrows of your keyboard to move the cursor one step at a time:

![Move cursor one step at a time](/assets/images/editor_tips/1_move_cursor.gif)

Using *option + cursor* move the cursor between words:

![Move cursor between words](/assets/images/editor_tips/2_move_cursor.gif)

User *cmd + cursor* to move the cursor to the end or beginning of line:

![Move cursor to the beginning of line](/assets/images/editor_tips/3_move_cursor.gif)

Using the *option* key, you can move any line:

![Move line](/assets/images/editor_tips/4_move_line.gif)

I use *cmd + x* to delete a line, this actually cuts it, but I don't really care:

![Delete line](/assets/images/editor_tips/5_delete_line.gif)

### Highlighting

This also seems silly, but it's important that we know them all.

Using *shift + cursor* we can highlight words character by character:

![Highlight characters](/assets/images/editor_tips/6_highlight.gif)

To improve this, we can use *shift + option + cursor* to highlight whole words:

![Highlight words](/assets/images/editor_tips/7_highlight.gif)

We can boost this using *shift * cmd + cursor* to select the entire line:

![Highlight line](/assets/images/editor_tips/8_highlight.gif)

### Multiple cursor magic

Now we are getting to the most important thing in my opinion, controlling multiple cursors.

First let's create them, we can use *cmd + click* using the mouse or *cmd + option + up/down cursor* with the keyboard only:

![Create multiple cursors](/assets/images/editor_tips/9_multi_line.gif)

Normally, the selections of each cursor are copied separately and you can copy and paste them anywhere. If you have the same number of cursors as when you copied this is what happens:

![Copy and paste multiple cursors](/assets/images/editor_tips/10_copy_multiple_elements.gif)

If you have a smaller or larger number of cursors than when you copied, all the copied selections will be pasted on every cursor you have at the moment.

I use the next one a lot. When you select something, you can use *cmd + d* to select the next matching selection. This is extremely useful as we will see in one of the examples at the end. Each selection will create a cursor for it:

![Same selection cursor](/assets/images/editor_tips/11_similar_highlighted.gif)

### Auto closing characters

These is similar to the HTML auto closing tags function (that I also recommend) but with characters that have a closing pair, for example:

![Double quotes](/assets/images/editor_tips/12_double_quote.gif)

![Single quotes](/assets/images/editor_tips/13_square_brackets.gif)

![Curly brackets](/assets/images/editor_tips/14_brackets.gif)

![Parenthesis](/assets/images/editor_tips/15_parenthesis.gif)

### Examples

All the previous blocks will be useful in %90 of the times (more or less). The examples I'll show you are simplified real case scenarios and I hope the animations are self-explanatory (if there is something unusual I will try to explain what I did).

![Exercise 1](/assets/images/editor_tips/exercise_1.gif)

Here I added a space at the beginning so I would get a cursor where I wanted (this is another trick that you learn from practice).

![Exercise 2](/assets/images/editor_tips/exercise_2.gif)

![Exercise 3](/assets/images/editor_tips/exercise_3.gif)

![Exercise 4](/assets/images/editor_tips/exercise_4.gif)

![Exercise 5](/assets/images/editor_tips/exercise_5.gif)

![Exercise 6](/assets/images/editor_tips/exercise_6.gif)

Of course there are other ways to solve them, your creativity is your limit!

## Extras

There are other features that editors have that you definitely should know:

* Find and open a file by name: in my case is *cmd + d* but other editors and IDEs have them mapped differently.
* Use autocompletion: if you develop in Java or similiar you are probably used to this, but editors have a lot of plugins for other languages that can help you.
* Find words in a file using regexp. This one is a bit more difficult (because you have to know regular expressions) but is very useful from time to time:

![Regexp selection](/assets/images/editor_tips/exercise_7.gif)

Once you found the text you want with your regexp, use *shift + cmd + L* to select it.

I hope you found these tricks useful and help you be more productive!

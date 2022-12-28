---
title: Add changes to previous git commits
published: true
description: Add changes to previous git commits
tags: git
layout: post_with_donation
date: 2022-12-28 00:00:00 -0300
categories: git
---

When we are developing, it is always recommended to commit our changes often and in logical units. For example, in a web application, we might need to add some field in the database and let the user change that field in a form. Using an MVC framework the steps would look like:

1. Add a migration that adds the field in the database
2. Add the field in the model
3. Pass the user input from the controller to the service that creates/updates the model
4. Add the input in the form

A common git practice would be to create commits for:

1. Adding the migration
2. Change the model, controller and service
3. Modify the form

Now, a very common scenario is that when we are changing the form we find out there was a bug in the service, or we want to change the field name to something more meaningful, or that we forgot to add the field in the model, etc. So how do we add those changes to previously committed files without removing our commits?

I'm going to show you 2 ways you can do this depending on how many commits behind you want to put those changes.

### Put your changes in the last commit

This is the simplest case, and you can use the following command that you may already know:

```bash
git add ...files

git commit --amend --no-edit
```

The `--no-edit` flag will skip the step where you can edit the commit message, if you don't pass this flag git will show you a text editor.

### Put changes in older commits

This is the more complex case and we are going to need the commit's hash we want to change. Following the previous MVC example, running `git log` returns something like this:

```
commit cc8a75f6753d07afaf0ece2b1a4eb26fbbfb3ec6 (HEAD -> main)

    Changed form

commit fa4f42bd629de581b48024465f90e61bf71734ae

    Changes in backend

commit 94b3af6d73d1c17518785a15a5e26c1ec3ce36fd

    Added migration
```

Let's say that we want to change the field name in the database, so out target commit is the one we added the migration (`94b3af6d73d1c17518785a15a5e26c1ec3ce36fd`). To do this you can run:

```bash
git add migration_file
git commit --fixup=94b3af6d73d1c17518785a15a5e26c1ec3ce36fd
git rebase --interactive --autosquash 94b3af6d73d1c17518785a15a5e26c1ec3ce36fd^
```

The `git commit --fixup=HASH` will create a commit with the same message as the mentioned commit with a prepended `fixup!`.
Then the `git rebase --interactive --autosquash HASH^` will automatically change the rebase message for you putting the fixup commit in the correct place (if the commit hash is correct and you used `^` at the end) and changing the word `edit` to `fixup`. After saving the message git will perform the desired changes.

### Another way to make changes in older commits

The previous way is a simplified version of a more complex process that you can do:

```bash
git stash
git rebase -i HEAD~3

Mark the commit you want to change by replacing edit with pick

git stash pop
git add ...files
git commit --amend --no-edit
git rebase --continue
```

In this case we stash our changes, then perform an interactive rebase. When changing `edit` to `pick` you are telling git to stop the rebase in that commit so you can add all the changes that you want. After doing the changes (in this case by doing a `stash pop`) you ammend the changes into the commit that you picked and then continue the rebase process.

## Very important

The 3 methods mentioned will change the hash of the modified commit and ALL it's children! This is very important because if a colleague is working on the same branch or if there are branches coming out of any of those commits you will find a lot of conflicts and commit dupications.

---
title: 'Taming a legacy android beast: The beginning'
date: 2019-12-09 23:47:57
tags: 
- android
- dev
---
## Introduction
Whether you are currently in a team that is developing an app that has a lot of __bad__ or __legacy__ code or you would like to revive an old app that you wrote 4 years ago, I will try to give some tips on how to iteratively better your app and codebase and slowly turn it into a mature project.

There are many ways to attack technical debt: 
- stopping new features and rewriting everything from the ground up
- constantly slowly refactoring everything one piece at a time while also working on more features
- just dealing with the shitty code

In most real life situations, a complete rewrite just isn't feasible, because it is expensive and your app might need to have new features added because of business reasons. Dealing with the shitty code, while short term might be fine, long term it will cause reoccuring bugs, things breaking 'accidentally' and adding new features gets more and more expensive and harder, since most of the time spent on developing a new feature is reading through old code.


> “Indeed, the ratio of time spent reading versus writing is well over 10 to 1. We are constantly reading old code as part of the effort to write new code. ...[Therefore,] making it easy to read makes it easier to write.”

> ― Robert C. Martin, Clean Code: A Handbook of Agile Software Craftsmanship


This leaves us with the second option: _iteratively refactoring_. 


## 1. GIT

I was not sure if I should include this, but this is probably the most important step, so why not.

If you are not using any form of version control, stop what you are doing right now, and read [this](https://hackernoon.com/please-use-git-da3bea7d1234)! Shame!

Also, use git in a responsible way. You should atleast:
- Create a separate branch for the "production" version of the app
- Create a separeate "dev" branch that you develop your features against.
- Use separate branches to develop new features or changes to the codebase
- Only merge code into dev through pull requests
- Avoid storing any secrets in version control
- Use git tags to mark app releases

I believe that the change to becoming a more mature team and more mature project starts from the team peer reviewing all code that goes into production and establishes clear code guidelines. One source of bad code is when developers do not fully understand how something works and create new code based on that shaky foundation of knowledge. Reviewing code increases the knowledge of the codebase for the whole team, and therefore lowers the changes of this happening.

### Example
An example of what the git flow could be:

`master <- dev <- feature/foo`

`master` would represent the production version of the app: When you push code into `master`, it means that a new version of the app is produced. After merging the pull request into master, the state of the repository would be tagged with a git tag. This should be done to easily go back in versions when you ever need to do that (You will at some point and you are going to thank me when you do).

 Think about `git checkout release_123` vs. digging through git history to try to find the right commit hash and checking out to that.

 `dev` would represent the developement branch. When you push code into `dev`, it means that a new feature is added to the app (a bug fix or literally a new feature). You would make a pull request and merge it to `master` when you would have the next app version ready


`feature/foo` would represent a feature branch. Each change (feature or bug fix) should have its own feature branch. This way multiple people can work on different things at the same time. When a feature is complete, it would have pull request made into `dev`. Someone (one or many people) would review it throughtly (__IMPORTANT!__). This would ideally be someone else than you, although you should always look through your code before asking anyone else to review it. After review, you would merge it into dev and delete the branch.



### What should you look for when reviewing code
I believe that [many](https://medium.com/palantir/code-review-best-practices-19e02780015f) more [smarter](https://blog.digitalocean.com/how-to-conduct-effective-code-reviews/) people [have](https://hackernoon.com/how-to-give-and-get-better-code-reviews-e011c3cda55e) already [tackled](https://mtlynch.io/human-code-reviews-1/) this [question](https://dev.to/codemouse92/10-principles-of-a-good-code-review-2eg), so I would suggest reading about it from somewhere else. 

Some things that might help you find bugs / improvements in native Android code:
- Look for the happy path and make sure that the business logic is correct
- Look for unhappy paths: network errors? exceptions?
- Does everything work on all API levels?
- What if the user puts your app on the background and the activity dies and needs to be recreated?
- Be conscious of recursion and retry logic for network requests 
- Usage of threads? background or main thread?
- Disable / Enable UI after user has engaged with it if necessary
- Think of code readability: variable naming, use language features efficiently
- Nullability (be careful of platform APIs when using Kotlin. Some platform APIs do not have support for nullability annotations and getters that might return null show up as nonnull in Android Studio "code suggestion" popup)
- "Anything that is possible, some user will do it"


 > tip: in Github you can configure the default branch to be something else than `master`, I would recommend setting it as your development branch, so that all pull requests are defaultly made into it, rather than `master`. This reduces mistakes where you accidentally merge feature branches into `master` instead of `dev`. 
 > https://help.github.com/en/articles/setting-the-default-branch

### Misc.
- Learn to use git with the command line: `git checkout` `git pull` `git fetch` `git rebase` `git log` `git reflog` `git cherry-pick` `git stash` `git diff` `git reset` `git blame` etc.

## 2. Crash reporting

A shared quality of almost every successful app is a bug free experience. I think that the priority 1 for all app developers should be to monitor bugs, crashes and try to catch them as early as possible. Bugs will happen, no matter how safe you try to be and how defensive you code.

### Pre-launch report

> The pre-launch report on your Play Console helps you identify:
>- Stability issues
>- Android compatibility issues
>- Performance issues
>- Accessibility issues
>- Security vulnerabilities

Pre-launch report is a great automation tool provided by Play console. You have no reason not to use it! [How to do it?](https://support.google.com/googleplay/android-developer/answer/7002270?hl=en)

I think the biggest value comes from the monkeytesting that it does for every release of your application. It clicks around in your app with different devices and reports if it can make the app crash. This is useful for detecting situations where your app crashes on startup. 

### 3rd party bug tracking
There are many 3rd party bug tracking libraries and services. They might help you with catching bugs. Some are: [Sentry.io](https://sentry.io), [AppCenter / Hockeyapp](https://appcenter.ms/), [Bugsnag](https://www.bugsnag.com/), [Firebase crashlytics](https://firebase.google.com/docs/crashlytics).

### Misc.
- If you are using RxJava 1 or 2, you can improve your "debugging a crash" experience with RxJava assembly tracking [RxJava 1](https://reactivex.io/RxJava/javadoc/rx/plugins/RxJavaHooks.html#enableAssemblyTracking--) [RxJava 2](https://github.com/akarnokd/RxJavaExtensions#debug-support). Uber also released a new RxJava 2 debugging library, [RxDogTag](https://github.com/uber/RxDogTag) that promises better results and better performance.

- Listen to your userbase: Although it should never happen that a bug goes live, If your users are complaining about about a bug, try to investigate and fix it asap. As a developer, you will never think of all the ways users might try to use your app, so if a bug description is given to you on a plate, eat the plate. and fix the bug! :D 

- Due to many manufacturers altering the OS, same code that works on one device, might not work on others. I have personally run into difficulties mostly with Huawei phones. I have run into problems especially with background services and video rendering. [Dont kill my app](https://dontkillmyapp.com/)

- Learn how to read [ANR](https://developer.android.com/topic/performance/vitals/anr) reports and native crash reports! This will help you debug complex bugs. I actually recommend reading the whole `vitals` section from the android documentation: [https://developer.android.com/topic/performance](https://developer.android.com/topic/performance)

## To be continued

Next part of the series will expand more upon: 
- Testing
- Continuous Integration & Continuous Delivery 
- Static code analysis

Coming soon :)


` 2019-12-09 23:47:57`

`- Zudoku`
 
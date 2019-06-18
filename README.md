<img src="http://www.zold.io/logo.svg" width="92px" height="92px"/>

[![Donate via Zerocracy](https://www.0crat.com/contrib-badge/CAZPZR9FS.svg)](https://www.0crat.com/contrib/CAZPZR9FS)

[![EO principles respected here](http://www.elegantobjects.org/badge.svg)](http://www.elegantobjects.org)
[![Managed by Zerocracy](https://www.0crat.com/badge/CAZPZR9FS.svg)](https://www.0crat.com/p/CAZPZR9FS)
[![DevOps By Rultor.com](http://www.rultor.com/b/yegor256/zold)](http://www.rultor.com/p/yegor256/zold)
[![We recommend RubyMine](http://www.elegantobjects.org/rubymine.svg)](https://www.jetbrains.com/ruby/)

[![Build Status](https://travis-ci.org/zold-io/zold-score.svg)](https://travis-ci.org/zold-io/zold-score)
[![Build status](https://ci.appveyor.com/api/projects/status/f4ct91inx6nfb5eg?svg=true)](https://ci.appveyor.com/project/yegor256/zold-score)
[![PDD status](http://www.0pdd.com/svg?name=zold-io/zold-score)](http://www.0pdd.com/p?name=zold-io/zold-score)
[![Gem Version](https://badge.fury.io/rb/zold-score.svg)](http://badge.fury.io/rb/zold-score)
[![Test Coverage](https://img.shields.io/codecov/c/github/zold-io/zold-score.svg)](https://codecov.io/github/zold-io/zold-score?branch=master)

[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/yegor256/takes/blob/master/LICENSE.txt)
[![Hits-of-Code](https://hitsofcode.com/github/zold-io/zold-score)](https://hitsofcode.com/view/github/zold-io/zold-score)

Here is the [White Paper](https://papers.zold.io/wp.pdf).

Join our [Telegram group](https://t.me/zold_io) to discuss it all live.

This small Ruby Gem calculates the score for Zold nodes. The idea of the
"score" is explained in the [White Paper](https://papers.zold.io/wp.pdf). To
get a better understanding of it you may want to read
[our blog](https://blog.zold.io).

To calculate a new Score you create an object first:

```ruby
score = Zold::Score.new(
  host: 'example.com',
  port: 4096,
  invoice: 'MYPREFIX@ffffffffffffffff',
  strength: 6
)
```

This score has zero value and the strength of six. Then you just ask it to calculate the next score:

```ruby
n = score.next
```

That's it.

This project is actively used in our [main Ruby repo](https://github.com/zold-io/zold).

## How to contribute

Read [these guidelines](https://www.yegor256.com/2014/04/15/github-guidelines.html).
Make sure you build is green before you contribute
your pull request. You will need to have [Ruby](https://www.ruby-lang.org/en/) 2.3+ and
[Bundler](https://bundler.io/) installed. Then:

```
$ bundle update
$ bundle exec rake
```

If it's clean and you don't see any error messages, submit your pull request.

# Zold Score Calculator, in Ruby and C++

[![EO principles respected here](https://www.elegantobjects.org/badge.svg)](https://www.elegantobjects.org)
[![DevOps By Rultor.com](https://www.rultor.com/b/yegor256/zold)](https://www.rultor.com/p/yegor256/zold)
[![We recommend RubyMine](https://www.elegantobjects.org/rubymine.svg)](https://www.jetbrains.com/ruby/)

[![rake](https://github.com/zold-io/zold-score/actions/workflows/rake.yml/badge.svg)](https://github.com/zold-io/zold-score/actions/workflows/rake.yml)
[![PDD status](https://www.0pdd.com/svg?name=zold-io/zold-score)](https://www.0pdd.com/p?name=zold-io/zold-score)
[![Gem Version](https://badge.fury.io/rb/zold-score.svg)](https://badge.fury.io/rb/zold-score)
[![Test Coverage](https://img.shields.io/codecov/c/github/zold-io/zold-score.svg)](https://codecov.io/github/zold-io/zold-score?branch=master)
[![License](https://img.shields.io/badge/license-MIT-green.svg)](https://github.com/yegor256/takes/blob/master/LICENSE.txt)
[![Hits-of-Code](https://hitsofcode.com/github/zold-io/zold-score)](https://hitsofcode.com/view/github/zold-io/zold-score)

Here is the [White Paper](https://papers.zold.io/wp.pdf).

Join our [Telegram group](https://t.me/zold_io) to discuss it all live.

This small Ruby Gem calculates the score for Zold nodes. The idea of the
"score" is explained in the [White Paper](https://papers.zold.io/wp.pdf).
To get a better understanding of it you may want to read
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

This score has zero value and the strength of six.
Then you just ask it to calculate the next score:

```ruby
n = score.next
```

That's it.

This project is actively used in our
[main Ruby repo](https://github.com/zold-io/zold).

## How to contribute

Read these [guidelines].
Make sure your build is green before you contribute your pull request.
You will need to have [Ruby](https://www.ruby-lang.org/en/) 2.3+ and
[Bundler](https://bundler.io/) installed.
Then:

```bash
bundle update
bundle exec rake
```

If it's clean and you don't see any error messages, submit your pull request.

[guidelines]: https://www.yegor256.com/2014/04/15/github-guidelines.html

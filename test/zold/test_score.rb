# frozen_string_literal: true

# SPDX-FileCopyrightText: Copyright (c) 2018-2025 Zerocracy
# SPDX-License-Identifier: MIT

require 'minitest/autorun'
require 'minitest/hooks/test'
require 'tmpdir'
require 'timeout'
require 'time'
require_relative '../../lib/zold/score'

# Score test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2018-2025 Zerocracy
# License:: MIT
class TestScore < Minitest::Test
  include Minitest::Hooks

  # We need this in order to make sure any test is faster than a minute. This
  # should help spotting tests that hang out sometimes. The number of seconds
  # to wait can be increased, but try to make it as little as possible,
  # in order to catch problems ealier.
  def around
    Timeout.timeout(10) do
      super
    end
  end

  def test_reduces_itself
    score = Zold::Score.new(
      time: Time.parse('2017-07-19T21:24:51Z'),
      host: 'localhost', port: 443, invoice: 'NOPREFIX@ffffffffffffffff',
      suffixes: %w[A B C D E F G]
    ).reduced(2)
    assert_equal(2, score.value)
    assert_equal(64, score.hash.length)
  end

  def test_compares
    score = Zold::Score.new(
      time: Time.parse('2017-07-19T21:24:51Z'),
      host: 'localhost', port: 443, invoice: 'NOPREFIX@ffffffffffffffff',
      suffixes: %w[A B C D E F G]
    )
    assert_equal(score, score.reduced(10))
  end

  def test_drops_to_zero_when_expired
    score = Zold::Score.new(
      time: Time.now - (Zold::Score::BEST_BEFORE * 60 * 60),
      host: 'some-host', port: 9999, invoice: 'NOPREFIX@ffffffffffffffff',
      strength: 50
    ).next
    assert_predicate(score, :valid?)
    refute_predicate(score, :expired?)
    assert_equal(0, score.value)
  end

  def test_validates_wrong_score
    score = Zold::Score.new(
      time: Time.parse('2017-07-19T21:24:51Z'),
      host: 'localhost', port: 443, invoice: 'NOPREFIX@ffffffffffffffff',
      suffixes: %w[xxx yyy zzz]
    )
    assert_equal(3, score.value)
    refute_predicate(score, :valid?)
  end

  def test_prints_mnemo
    score = Zold::Score.new(
      time: Time.parse('2017-07-19T22:32:51Z'),
      host: 'localhost', port: 443, invoice: 'NOPREFIX@ffffffffffffffff'
    )
    assert_equal('0:2232', score.to_mnemo)
  end

  def test_prints_and_parses
    time = Time.now
    score = Zold::Score.parse(
      Zold::Score.new(
        time: time, host: 'localhost', port: 999,
        invoice: 'NOPREFIX@ffffffffffffffff',
        strength: 1
      ).next.next.to_s
    )
    assert_equal(2, score.value)
    assert_equal(score.time.utc.iso8601, time.utc.iso8601)
    assert_equal('localhost', score.host)
    assert_equal(999, score.port)
  end

  def test_parses_broken_text
    text = 'some garbage to parse, which can\'t be parsed'
    ex = assert_raises(Zold::Score::CantParse) do
      Zold::Score.parse(text)
    end
    assert_includes(ex.message, text, ex)
  end

  def test_prints_and_parses_zero_score
    time = Time.now
    before = Zold::Score.new(
      time: time, host: '192.168.0.1', port: 1,
      invoice: 'NOPREFIX@ffffffffffffffff', suffixes: []
    )
    text = before.to_s.strip
    after = Zold::Score.parse(text)
    assert_equal(before.value, after.value)
    refute_predicate(after, :expired?)
  end

  def test_finds_next_score
    score = Zold::Score.new(
      time: Time.now, host: 'localhost', port: 443,
      invoice: 'NOPREFIX@ffffffffffffffff', strength: 2
    ).next.next.next
    assert_equal(3, score.value)
    assert_predicate(score, :valid?)
    refute_predicate(score, :expired?)
  end

  def test_dont_expire_correctly
    score = Zold::Score.new(
      time: Time.now - (10 * 60 * 60), host: 'localhost', port: 443,
      invoice: 'NOPREFIX@ffffffffffffffff', strength: 2
    ).next.next.next
    refute_predicate(score, :expired?)
  end

  def test_is_not_valid_if_time_is_in_future
    score = Zold::Score.new(
      time: Time.now + (60 * 60), host: 'localhost', port: 443,
      invoice: 'NOPREFIX@ffffffffffffffff', strength: 2
    )
    refute_predicate(score, :valid?)
  end

  def test_correct_number_of_zeroes
    score = Zold::Score.new(
      time: Time.now, host: 'localhost', port: 443,
      invoice: 'NOPREFIX@ffffffffffffffff', strength: 3
    ).next
    assert(score.hash.end_with?('000'))
  end

  def test_generates_hash_correctly
    score = Zold::Score.new(
      time: Time.parse('2018-06-27T06:22:41Z'), host: 'b2.zold.io', port: 4096,
      invoice: 'THdonv1E@abcdabcdabcdabcd', suffixes: ['3a934b']
    )
    assert_equal(
      'c9c72efbf6beeea13408c5e720ec42aec017c11c3db335e05595c03755000000',
      score.hash
    )
    score = Zold::Score.new(
      time: Time.parse('2018-06-27T06:22:41Z'), host: 'b2.zold.io', port: 4096,
      invoice: 'THdonv1E@abcdabcdabcdabcd', suffixes: %w[3a934b 1421217]
    )
    assert_equal(
      'e04ab4e69f86aa17be1316a52148e7bc3187c6d3df581d885a862d8850000000',
      score.hash
    )
  end

  def test_lets_the_thread_to_die
    score = Zold::Score.new(
      host: 'localhost', invoice:
      'NOPREFIX@ffffffffffffffff', strength: 30
    )
    thread = Thread.start do
      score.next
    end
    sleep(0.1)
    thread.kill
    thread.join
  end
end

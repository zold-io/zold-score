# frozen_string_literal: true

# Copyright (c) 2018 Yegor Bugayenko
#
# Permission is hereby granted, free of charge, to any person obtaining a copy
# of this software and associated documentation files (the 'Software'), to deal
# in the Software without restriction, including without limitation the rights
# to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
# copies of the Software, and to permit persons to whom the Software is
# furnished to do so, subject to the following conditions:
#
# The above copyright notice and this permission notice shall be included in all
# copies or substantial portions of the Software.
#
# THE SOFTWARE IS PROVIDED 'AS IS', WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
# IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
# FITNESS FOR A PARTICULAR PURPOSE AND NONINFINGEMENT. IN NO EVENT SHALL THE
# AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
# LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
# OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
# SOFTWARE.

require 'minitest/autorun'
require 'minitest/hooks/test'
require 'tmpdir'
require 'timeout'
require 'time'
require 'timecop'
require_relative '../../lib/zold/score'

# Score test.
# Author:: Yegor Bugayenko (yegor256@gmail.com)
# Copyright:: Copyright (c) 2018 Yegor Bugayenko
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

  MORE_THEN_DAY = 24 * 60 * 60 + 1

  def test_time_shift
    string_time = '2018-12-03T06:19:25Z'
    today = Time.parse string_time
    tomorrow = today + MORE_THEN_DAY

    score = Zold::Score.parse(
      "234/7: #{string_time} 94.232.57.6 4096 66Yodh14@1142c2d008235bbe 8GAPAl xfs416 2pcZ2X 2jrGW7 D3QSeI 43iCI5 O6d0Wt lD1UCM 6X4h1r 1OIdNp fyvUDf jmTqHG NcqgvK xpFZx4 tSdYNg SshZaI O3SMO3 InLSCU 07Mz4Y BrgT9h ks230K d5DkfY pj2RvN FIFIx4 SAQXEu LPqQJZ cbhTYe f1iFFL b2N5Yp Pl3pEv NugJPD FBxKj4 Sj3Puv MMxoI0 KS4lIo qdl0qw sBeyPU wLloKy QfidvM UyaryC nrwQgL TxB0ct 9OpOov KVUTA4 2OT2xc U9jPt9 suxLKN UvsWna 9hL9ts 1xl4mt l9q88E 5jNLIk yTEkHY mMTzbs kJf0ZV 7DGDYR 6lMHTv toFiXu 7R57SM 1FDMeC 4CJs3v ekxDea LRrWSc QZVC3b sSWpZE VIL1IK gHhTEu 0xdkju 9yT2SI aqFsbL moSX1v gTgXz8 88ljMU fh03E9 VZezW6 wNxd4w h17XYV 3mhDWb dXWMpD zi220A u5j00S Sd2dbR wXh71b eAGcd3 mW4M1A eimiNK MdyafC zGScqD PE17kv OvYqK5 oYWbUT 1UwH3D ItglP1 qo1oA1 d0PyGe pYQ8w5 7rKcrQ 9ObHg2 ib94Je ig17Jl ZVGwon 4A4Ft3 v0rTZW A8sNyl 0FwMc8 KdNGHp usp03q sTwaB3 gQDyAo 8uroR4 v2YWFV TtxqK3 0ZPToP S2pVHl 9JnduV bsmP5A WONzUx Sqw9me ZqCcep QH4MhS Mx44DO 873cSX fQSxwt wtySrd ZWoopv 3NFQmg Kn9T7W EH9LBg 3u8pSS 3onAMb OHFVoS C70nHC gXA7Ue bP3xpk BynnhJ zG1vcg 535DVw I3xhr1 EOLk4A raXI6K mTG3L4 Xk8e7b gDuulv d1euiN GTbrAL xqdTuL 8BnaQG ydXGkf lSrd5Z dGxNhi ckbckH 5kMWbp 68GXMI 597n5F bOTWDy OBdHxe KNSppq 1CPVNV QhMH2e 3l1cKT ZCSahN tY9V1y 70pWR8 Ygjof2 xqOcuO dIptrV eytpAC INTgf9 D0sAK4 cjhcF0 occlil Fyru2r A8RzRt Dskx0p O8AsMv s961Nk lnziCh t3FJVu gayLha RPCXgK J8qn7B kJtXTi ln0btj IKk6a4 au0IDT szD3Cn e0Ne5U n7ZCKv dnV08u rIR9Dq mfd5Og 9sQkez 6BGfMp W3L6V0 NxBAH0 OqXq5D GOSU8t vK4xGe UxYajD fJCVuN rYKSEs L5aZx0 Z1uVeK CbROq1 3av5dT wBX8SJ jSUDj0 N4GFk9 4vTC1e sYxCR2 5rlheu A60dbW MneQOP YSUoTO nyHMMD kWoHEM c5xPec r2LJTy j3ZUja 3yJrgc XGg66T XxuyFe lH6TIC LrVIjq 7Nzitw 11f0kN Ha9bdu 4vorZX JqulY2 mRmrxw FSHKgp E6eG9L IgZBhY CKGFml" # rubocop:disable Metrics/LineLength
    )

    assert(score.valid?)
    assert_equal(234, score.value)

    Timecop.freeze(today) do
      assert(!score.expired?)
    end

    Timecop.freeze(tomorrow) do
      assert(score.expired?)
      assert(score.valid?)
    end
  end

  # Reduces suffixes list
  #
  def test_reduces_itself
    score = Zold::Score.new(
      time: Time.parse('2017-07-19T21:24:51Z'),
      host: 'localhost', port: 443, invoice: 'NOPREFIX@ffffffffffffffff',
      suffixes: %w[A B C D E F G]
    )

    assert_equal(7, score.value)
    assert_equal(7, score.suffixes.length)
    assert_equal(64, score.hash.length)

    score = score.reduced(2)
    assert_equal(2, score.value)
    assert_equal(2, score.suffixes.length)
    assert_equal(64, score.hash.length)
  end

  def test_drops_to_zero_when_expired
    score = Zold::Score.new(
      time: Time.now - 24 * 60 * 60,
      host: 'some-host', port: 9999, invoice: 'NOPREFIX@ffffffffffffffff',
      strength: 50
    ).next
    assert(score.valid?)
    assert(!score.expired?)
    assert_equal(0, score.value)
  end

  def test_validates_wrong_score
    score = Zold::Score.new(
      time: Time.parse('2017-07-19T21:24:51Z'),
      host: 'localhost', port: 443, invoice: 'NOPREFIX@ffffffffffffffff',
      suffixes: %w[xxx yyy zzz]
    )
    assert_equal(3, score.value)
    assert(!score.valid?)
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
        time: time, host: 'localhost', port: 999, invoice: 'NOPREFIX@ffffffffffffffff',
        strength: 1
      ).next.next.to_s
    )
    assert_equal(2, score.value)
    assert_equal(score.time.to_s, time.to_s)
    assert_equal('localhost', score.host)
    assert_equal(999, score.port)
  end

  def test_parses_broken_text
    ex = assert_raises do
      Zold::Score.parse('some garbage')
    end
    assert(ex.message.include?('Invalid score'), ex)
  end

  def test_prints_and_parses_text
    time = Time.now
    score = Zold::Score.parse_text(
      Zold::Score.new(
        time: time, host: 'a.example.com', port: 999, invoice: 'NOPREFIX@ffffffffffffffff',
        strength: 1
      ).next.next.next.to_text
    )
    assert_equal(3, score.value)
    assert_equal(score.time.utc.to_s, time.utc.to_s)
    assert_equal('a.example.com', score.host)
    assert_equal(999, score.port)
  end

  def test_prints_and_parses_text_zero_score
    time = Time.now
    score = Zold::Score.parse_text(
      Zold::Score.new(
        time: time, host: '192.168.0.1', port: 1, invoice: 'NOPREFIX@ffffffffffffffff', suffixes: []
      ).to_text
    )
    assert_equal(0, score.value)
    assert(!score.expired?)
  end

  def test_prints_and_parses_zero_score
    time = Time.now
    score = Zold::Score.parse(
      Zold::Score.new(
        time: time, host: '192.168.0.1', port: 1, invoice: 'NOPREFIX@ffffffffffffffff', suffixes: []
      ).to_s
    )
    assert_equal(0, score.value)
    assert(!score.expired?)
  end

  def test_finds_next_score
    score = Zold::Score.new(
      time: Time.now, host: 'localhost', port: 443,
      invoice: 'NOPREFIX@ffffffffffffffff', strength: 2
    ).next.next.next
    assert_equal(3, score.value)
    assert(score.valid?)
    assert(!score.expired?)
  end

  def test_dont_expire_correctly
    score = Zold::Score.new(
      time: Time.now - 10 * 60 * 60, host: 'localhost', port: 443,
      invoice: 'NOPREFIX@ffffffffffffffff', strength: 2
    ).next.next.next
    assert(!score.expired?)
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
    assert_equal('c9c72efbf6beeea13408c5e720ec42aec017c11c3db335e05595c03755000000', score.hash)
    score = Zold::Score.new(
      time: Time.parse('2018-06-27T06:22:41Z'), host: 'b2.zold.io', port: 4096,
      invoice: 'THdonv1E@abcdabcdabcdabcd', suffixes: %w[3a934b 1421217]
    )
    assert_equal('e04ab4e69f86aa17be1316a52148e7bc3187c6d3df581d885a862d8850000000', score.hash)
  end

  def test_lets_the_thread_to_die
    score = Zold::Score.new(host: 'localhost', invoice: 'NOPREFIX@ffffffffffffffff', strength: 30)
    thread = Thread.start do
      score.next
    end
    sleep(0.1)
    thread.kill
    thread.join
  end
end

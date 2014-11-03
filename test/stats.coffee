{expect} = require 'chai'
Stats = require '../src/stats'
RawStats = require './fixtures/raw_stats'

describe 'stats.parse', ->
  stats = {}

  beforeEach ->
    stats = Stats.parse RawStats.get()

  it 'converts pageTiming numbers to durations', ->
    expect(stats.responseStart).to.equal 10

  it 'leaves out any zeros', ->
    expect(stats.unloadEventStart).to.not.exist

  it 'sets duration to the value of loadEventEnd', ->
    expect(stats.duration).to.equal 18

  it 'rounds out the resource timings', ->
    expect(stats.resources[0].duration).to.equal 505

  it 'sorts the resources array by startTime', ->
    last = 0
    for r in stats.resources
      expect(last).to.be.at.most r.startTime
      last = r.startTime

  it 'sets totalLoadTime to when after all resources have loaded', ->
    expect(stats.totalLoadTime).to.equal 1280

  it 'sets the totalLoadTime to the loadEventEnd when its longer', ->
    rawStats = RawStats.get()
    rawStats.pageTiming.loadEventEnd = rawStats.pageTiming.navigationStart + 9999
    stats = Stats.parse rawStats

    expect(stats.totalLoadTime).to.equal 9999

  describe 'hosts', ->
    it 'lists the hosts used in the resources', ->
      expect(stats.hostLatency).to.include.keys [
        'http://pixel.quantserve.com',
        'http://cdn.optimizely.com',
        'http://dc8hdnsmzapvm.cloudfront.net'
      ]

    it 'sets the host value to the max latency found for that host', ->
      expect(stats.hostLatency['http://pixel.quantserve.com']).to.equal 10

{expect} = require 'chai'
fs = require 'fs'
Stats = require '../src/stats'

describe 'stats.parse', ->
  stats = {}

  before ->
    rawStats = fs.readFileSync "#{__dirname}/fixtures/raw_stats.json", 'utf8'
    stats = Stats.parse JSON.parse rawStats

  it 'sets resourcesLoaded to the last resource load time', ->
    expect(stats.resourcesLoaded).to.equal 5678

  it 'determines largest resource', ->
    expect(stats.largestResource.size).to.equal 666

  it 'dtermines smallest resource', ->
    expect(stats.smallestResource.size).to.equal 259

  it 'determines fastest host', ->
    expect(stats.fastestHost).to.equal 'http://i.stack.imgur.com'

  it 'determines slowest host', ->
    expect(stats.slowestHost).to.equal 'http://cdn.sstatic.net'

  describe 'hosts', ->
    it 'determines the unique list of hosts', ->
      expect(stats.hosts).to.include.keys [
        'http://stackoverflow.com'
        'http://ajax.googleapis.com'
        'http://cdn.sstatic.net'
        'http://i.stack.imgur.com'
      ]

    it 'determines host speed', ->
      expect(stats.hosts['http://i.stack.imgur.com'].speed).to.be.closeTo 0.39, 0.001

    it 'determines the number of resources', ->
      expect(stats.hosts['http://cdn.sstatic.net'].resourceCount).to.equal 2


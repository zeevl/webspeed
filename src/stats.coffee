_ = require 'underscore'
Url = require 'url'

module.exports =
  parse: (rawStats) ->
    return unless rawStats

    stats = @initStats rawStats
    stats = @processResources stats, rawStats
    stats = @averageHostSpeeds stats

    return stats

  initStats: (rawStats) ->
    _.extend _.clone(rawStats),
      resources: []
      hosts: {}
      resourcesLoaded: rawStats.loadEventEnd

  processResources: (stats, rawStats) ->
    for k, r of rawStats.resources
      stats.resources.push r
      stats.resourcesLoaded = Math.max stats.resourcesLoaded, r.end

      url = Url.parse r.url
      host = "#{url.protocol}//#{url.host}"
      stats.hosts[host] ?=
        speeds: []
        resourceCount: 0

      stats.hosts[host].resourceCount++

      if r.size
        if not stats.largestResource or stats.largestResource.size < r.size
          stats.largestResource = r

        speed = ((r.size * 8.0) / (r.duration / 1000.0)) / 1000.0

        stats.hosts[host].speed = parseFloat speed.toFixed 2
        stats.hosts[host].speeds.push stats.hosts[host].speed

    return stats

  averageHostSpeeds: (stats) ->
    for k, host of stats.hosts when host.speeds.length > 0
      host.speed = host.speeds
        .map (x, i, arr) -> x / arr.length
        .reduce (a, b) -> a + b

      if not stats.slowestHost or stats.hosts[stats.slowestHost].speed < host.speed
        stats.slowestHost = k

      delete host.speeds

    return stats

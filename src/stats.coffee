_ = require 'underscore'
Url = require 'url'

module.exports =
  parse: (rawStats) ->
    return unless rawStats

    start = rawStats.pageTiming.navigationStart
    parsedStats = {}

    for k, v of rawStats.pageTiming
      if v then parsedStats[k] = v - start

    parsedStats.duration = parsedStats.loadEventEnd
    parsedStats.resources = _.sortBy rawStats.resourceTiming, (r) -> r.startTime

    parsedStats.resources = @roundNumbers parsedStats.resources

    maxResource = _.max rawStats.resourceTiming, (r) -> r.responseEnd

    parsedStats.totalLoadTime = Math.max Math.round(maxResource.responseEnd),
      parsedStats.loadEventEnd

    parsedStats.hostLatency = @getHostLatencies parsedStats.resources

    return parsedStats

  roundNumbers: (resources) ->
    _.map resources, (resource) ->
      newr = {}
      newr[k] = (if isNaN(v) then v else Math.round v) for k, v of resource
      return newr

  getHostLatencies: (resources) ->
    hosts = {}
    for resource in resources
      url = Url.parse resource.name
      host = "#{url.protocol}//#{url.host}"
      latency = resource.responseEnd - resource.fetchStart
      hosts[host] = Math.max latency, (hosts[host] or 0)

    return hosts




_ = require 'underscore'
Url = require 'url'

module.exports =
  parse: (rawStats) ->
    return unless rawStats

    start = rawStats.pageTiming.navigationStart
    parsedStats = {}

    maxTime = 0
    for k, v of rawStats.pageTiming when v
      parsedStats[k] = v - start
      maxTime = Math.max maxTime, parsedStats[k]

    parsedStats.duration = maxTime
    parsedStats.resources = _.sortBy rawStats.resourceTiming, (r) -> r.startTime

    parsedStats.resources = @roundNumbers parsedStats.resources

    maxResource = _.max rawStats.resourceTiming, (r) -> r.responseEnd
    resourceLoadTime = Math.round(maxResource.responseEnd) or 0

    parsedStats.totalLoadTime =
      Math.max parsedStats.duration, resourceLoadTime


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




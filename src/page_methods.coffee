
# NOTE: These methods are run in the context of the browser page.
# Each method is passed individual to the brower context, and so
# must be fully self-contained.
module.exports =
  getPerformance: (callback) ->
    to = 0
    setStatsTimeout = (ms) ->
      clearTimeout to
      to = setTimeout ->
        callback
          pageTiming: window.performance.timing
          resourceTiming: window.performance.getEntries()
      , ms

    # when the document is complete, wait another 10s
    # for onload to finish.
    if document.readyState is 'complete'
      setStatsTimeout 10 * 1000
    else
      document.onreadystatechange = ->
        if document.readyState is 'complete'
          setStatsTimeout 10 * 1000

    window.onload = ->
      setStatsTimeout 10

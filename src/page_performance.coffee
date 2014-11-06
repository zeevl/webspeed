page = require('webpage').create()

if phantom.args.length is 0
  console.log 'ERROR: Url must be specified as a parameter!'
  phantom.exit();

url = phantom.args[0]
stats = {}
resources = {}

# This avoids complaints by phantomjs about cross-site scripting..
exit = (code) ->
  # phantom sometimes logs it's own output, which is super annoying.
  # so give the caller something to parse out
  console.log 'JSON:' + JSON.stringify stats
  if page then page.close()
  setTimeout ->
    phantom.exit(code)
  , 0

exitTimer = 0
resetExitTimer = ->
  clearTimeout exitTimer
  exitTimer = setTimeout exit, 2000

page.onCallback = (data) ->
  stats.domContentLoaded = data.domContentLoaded
  stats.loadEventStart = data.loadEventStart
  stats.loadEventEnd = data.loadEventEnd
  stats.resources = resources

  resetExitTimer()


# Use this for diagnosing issues with page.evaluate scripts..
#
# page.onError = (msg, trace) ->
#   stack = ["PHANTOM ERROR:  #{msg}"]
#   if trace
#     stack.push " -> #{t.file or t.sourceURL}: #{t.line}" for t in trace

#   console.error stack.join '\n'
#   exit(1)

# page.onConsoleMessage = (msg) ->
#   console.log 'CONSOLE: ' + msg

page.onLoadStarted = ->
  stats.latency = Date.now() - startTime

page.onLoadFinished = ->
  stats.pageLoaded = Date.now() - startTime
  resetExitTimer()

page.onInitialized = ->
  page.evaluate (startTime) ->
    timer = 0
    eventTiming = {}

    setStatsTimeout = (ms) ->
      clearTimeout timer
      timer = setTimeout ->
        window.callPhantom eventTiming
      , ms

    document.onreadystatechange = ->
      window.callPhantom eventTiming

    # all sorts of ways this will be inaccurate, but until
    # phantomjs supports window.performance this is the
    # best we can do..
    #
    oldOnLoad = null
    document.addEventListener 'DOMContentLoaded', ->
      eventTiming.domContentLoaded = Date.now() - startTime
      oldOnLoad = window.onload
      window.onload = null
      window.callPhantom eventTiming

    window.addEventListener 'load', ->
      eventTiming.loadEventStart = Date.now() - startTime
      # let any other
      setTimeout ->
        eventTiming.loadEventEnd = Date.now() - startTime
        window.callPhantom eventTiming
      , 0

      oldOnLoad?()
  , startTime

page.onResourceRequested = (r) ->
  resources[r.id] =
    start: Date.now() - startTime
    url: r.url

  resetExitTimer()

page.onResourceReceived = (r) ->
  resetExitTimer()

  resources[r.id].end = Date.now() - startTime
  resources[r.id].duration = resources[r.id].end - resources[r.id].start
  if r.bodySize then resources[r.id].size = r.bodySize

  unless r.bodySize
    for header in r.headers when header.name.toLowerCase() is 'content-length'
      resources[r.id].size = parseInt(header.value)
      resources[r.id].fromheaders = true


startTime = Date.now();
page.open url, (status) ->
  stats.url = url


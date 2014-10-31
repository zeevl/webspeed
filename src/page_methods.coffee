
# NOTE: These methods are run in the context of the browser page.
# Each method is passed individual to the brower context, and so
# must be fully self-contained.
module.exports =
  getPerformance: (callback) ->
    isComplete = ->
      document.readyState == 'complete'

    waitForComplete = (done) ->
      if isComplete then done(); return
      i = setInterval ->
        if document.readyState == 'complete'
          clearInterval i
          done();
      , 10

    waitForComplete ->
      stats =
        pageTiming: window.performance.timing
        resourceTiming: window.performance.getEntries()

      callback stats

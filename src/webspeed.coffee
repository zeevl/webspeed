_ = require 'underscore'
async = require 'async'
fs = require 'fs'
seleniumStandalone = require 'selenium-standalone'
webdriverio = require 'webdriverio'
pageMethods = require './page_methods'
Stats = require './stats'

module.exports =
  run: (url, options, callback) ->
    if _.isFunction(options)
      callback = options
      options = {}

    options = _.extend
      timeout: 30 * 1000
      disableCache: false
    , options

    webdriverOptions =
      desiredCapabilities:
        browserName: 'chrome'

    if options.disableCache
      webdriverOptions.desiredCapabilities.chromeOptions =
        args: [
          'disable-media-cache'
          'disable-application-cache'
          'disk-cache-size=1'
          'media-cache-size=1'
          'disk-cache-dir=/dev/null'
        ]

    # are we starting selenium in this run()?
    iStartedSelenium = not @selenium

    @startSelenium =>
      webdriverio
        .remote(webdriverOptions)
        .init()
        .timeoutsAsyncScript options.timeout
        .url url
        .executeAsync pageMethods.getPerformance, (err, stats) ->
          callback err, Stats.parse stats?.value
        .end =>
          if iStartedSelenium then @selenium.kill()


  startSelenium: (callback) ->
    if @selenium then callback(null, @selenium); return

    @selenium = seleniumStandalone stdio: 'pipe'

    @selenium.on 'error', (err) ->
      console.log 'selenium child process error! ', err

    @selenium.stderr.on 'data', (output) ->
      str = output.toString()

      if str.indexOf('Started SocketListener') isnt -1
        callback null, @selenium

  stopSelenium: ->
    @selenium?.kill()


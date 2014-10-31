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

    options = _.extend timeout: 10000, options

    webdriverOptions =
      desiredCapabilities:
        browserName: 'chrome'
        chromeOptions:
          # this isn't working..
          args: ['--disable-application-cache', '--start-maximized']

    @startSelenium =>
      webdriverio
        .remote(webdriverOptions)
        .init()
        .timeoutsAsyncScript options.timeout
        .url url
        .executeAsync pageMethods.getPerformance, (err, stats) ->
          callback err, Stats.parse stats?.value
        .end =>
          @selenium.kill()


  startSelenium: (callback) ->
    if @selenium then callback(null, @selenium); return

    @selenium = seleniumStandalone stdio: 'pipe'

    @selenium.on 'error', (err) ->
      console.log 'selenium child process error! ', err

    @selenium.on 'exit', (code) ->
      console.log 'selenium exited with code ', code

    @selenium.stderr.on 'data', (output) ->
      str = output.toString()
      console.log str
      if str.indexOf('Started SocketListener') isnt -1
        callback null, @selenium

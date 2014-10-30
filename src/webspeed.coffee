async = require 'async'
fs = require 'fs'
seleniumStandalone = require 'selenium-standalone'
webdriverio = require 'webdriverio'


module.exports =
  run: (url, callback) ->
    webdriverOptions =
      desiredCapabilities:
        browserName: 'chrome'

    async.parallel
      js: (done) => @readScript done
      server: (done) => @startSelenium done
    , (err, results) =>
      if err then callback(err, null); return

      webdriverio
        .remote(webdriverOptions)
        .init()
        .url url
        .execute results.js, (err, stats) ->
          callback null, stats.value
        .end =>
          @selenium.kill()

  readScript: (callback) ->
    if @js then callback(null, @js); return

    fs.readFile "#{__dirname}/js/perfStats.js", encoding: 'utf8', (err, js) ->
      @js = js
      callback err, js

  startSelenium: (callback) ->
    if @selenium then callback(null, @selenium); return

    @selenium = seleniumStandalone stdio: 'pipe'

    @selenium.on 'error', (err) ->
      console.log 'selenium child process error! ', err

    @selenium.on 'exit', (code) ->
      console.log 'selenium exited with code ', code

    @selenium.stderr.on 'data', (output) ->
      str = output.toString()

      if str.indexOf('Started SocketListener') isnt -1
        callback null, @selenium

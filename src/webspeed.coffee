_ = require 'underscore'
path = require 'path'
childProcess = require 'child_process'
phantomPath = require('phantomjs').path
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

    # handle the case when 'google.com' is passed in, instead
    # of 'http://google.com'
    unless /^http/.test(url) then url = 'http://' + url

    phantomArgs = [
      path.join __dirname, './page_performance.coffee'
      url
    ]

    childProcess.execFile phantomPath, phantomArgs, {timeout: 30000}, (err, stdout, stderr) ->
      match = stdout.match /JSON:(.+)/
      if not match
        callback new Error 'Invalid output from phantom!\n' + stdout

      result = null
      try
        result = JSON.parse match[1]
      catch e
        callback new Error 'Error parsing phantom output!\n' + stdout, e

      callback null, Stats.parse result

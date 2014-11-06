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

    phantomArgs = [
      path.join __dirname, './page_performance.coffee'
      url
    ]

    childProcess.execFile phantomPath, phantomArgs, {timeout: 30000}, (err, stdout, stderr) ->
      console.log stdout

      match = stdout.match /JSON:(.+)/
      if not match
        throw new Error 'Invalid output from phantom!\n' + stdout

      try
        console.log JSON.parse match[1]
      catch e
        throw new Error 'Error parsing phantom output!\n' + stdout, e

      callback()

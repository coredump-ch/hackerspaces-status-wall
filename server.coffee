express = require 'express'
request = require 'request'

app = express.createServer()

app.configure ->
  app.use require('connect-assets')
    jsCompilers: require('./jade-assets')
  app.use express.bodyParser()
  app.set 'view options', {layout: false}

app.get '/wall', (req, res) ->
  res.render 'wall.jade'

app.post '/proxy', (req, res) ->
  request req.body.url, (error, apiResponse, apiBody) ->
    if error?
      res.send error if error?
    else
      try
        res.send
          "headers": apiResponse.headers
          "body": JSON.parse apiBody
      catch ex
        res.send
          "headers": apiResponse.headers
          "body": apiBody
          "error": ex.message

app.get '*', (req, res) ->
  res.redirect 'wall'

port = process.env.PORT
app.listen port, () -> console.log "Listening on port #{port}"

io = require('socket.io').listen(app)

io.configure () ->
  io.set "transports", ["xhr-polling"]
  io.set "polling duration", 10

twitter = require './lib/twitter'

io.sockets.on 'connection', (socket) ->
  socket.on 'previous tweets', (max) ->
    twitter.recent max, (err, tweet) ->
      socket.emit 'previous tweet', tweet if !err

twitter.listen (tweet) ->
  io.sockets.emit 'new tweet', tweet

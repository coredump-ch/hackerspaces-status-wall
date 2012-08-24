request = require 'request'
async = require 'async'

latest = (collection, callback) ->
  collection
    .find()
    .sort({$natural: -1})
    .limit(1)
    .toArray (err, list) ->
      if err
        callback err
      else
        callback err, list[0]

update_spaces = (directories, spaces, callback) ->
  update_space = (space, callback) ->
    console.log "requesting #{space.url}"
    request space.url, (err, res, body) ->
      if err
        console.log "error for #{space.name}: #{err}"
        callback()
      else
        console.log "reply for #{space.name}"
        status = JSON.parse body
        spaces.insert {date: new Date(), status: status}, (err) ->
          if err
            console.log err
          else
            console.log "saved for #{space.name}"
          callback()

  latest directories, (err, directory) ->
    if err
      callback err
    else
      console.log "directory found for #{directory.date}"
      entries = for name, url of directory.spaces
        {name: name, url: url}
      async.forEach entries, update_space, (err) ->
        callback err

require('./database')
  .connect 'directories', 'spaces', (err, db, directories, spaces) ->
    if err
      console.log err
      process.exit()
    else
      update_spaces directories, spaces, (err) ->
        process.exit()

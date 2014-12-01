Template._comment.events
  "click .upvote": (e, t) ->
    Meteor.call "voteComment", @_id, true, (err, res) ->
      if err then console.log err
  "click .downvote": (e, t) ->
    Meteor.call "voteComment", @_id, false, (err, res) ->
      if err then console.log err

Template._postTeaser.helpers
  timeAgo: ->
    return moment(@date).fromNow()
  upvoted: ->
    return _.include @upvoters, Meteor.userId()
  downvoted: ->
    return _.include @downvoters, Meteor.userId()

Template._postTeaser.events
  "click .vote.up": (e, t) ->
    Meteor.call "votePost", @_id, true, (err, res) ->
      if err then console.log err
  "click .vote.down": (e, t) ->
    Meteor.call "votePost", @_id, false, (err, res) ->
      if err then console.log err

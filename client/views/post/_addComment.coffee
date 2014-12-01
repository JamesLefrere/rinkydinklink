Template._addComment.rendered = ->
  $("#comment").autosize()

Template._addComment.events
  "submit #add-comment": (e, t) ->
    e.preventDefault()
    comment = $("#comment").val()
    if comment.length is 0 then return false
    data =
      body: comment
      postId: @post._id
    Meteor.call "addComment", data, (err, res) ->
      if err
        console.log err
      else
        console.log "Added comment", res

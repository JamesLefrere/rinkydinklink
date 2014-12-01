Template.post.helpers
  type: ->
    if @post.body.length > 120 then return "long"
    if typeof @post.url isnt "undefined" then return "link"
    return "short"
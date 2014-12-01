Template._addPost.created = ->
  @type = new ReactiveVar "type"
  @type.set "Short post"

Template._addPost.rendered = ->
  $("#body").autosize()

Template._addPost.helpers
  type: ->
    return Template.instance().type.get()

Template._addPost.events
  "change #body, change #url, keydown #body, keydown #url, focusout #body, focusout #url": ->
    Template.instance().type.set setPostType()

  "submit form": (e, t) ->
    e.preventDefault()
    data =
      body: $("#body").val()
      url: $("#url").val()
      tags: $("#tags").val().split(",")
    Meteor.call("addPost", data, (err, res) ->
      if err
        console.log err
      else
        Router.go "post", _id: res
    )

setPostType = ->
  if $("#body").val().length > 120
    $("#url").attr("disabled", "disabled")
    return "Long post"
  else
    $(".field-url").removeAttr("disabled")
  if $("#url").val().length > 0 and $("#url").val() != ""
    return "Link post"
  return "Short post"

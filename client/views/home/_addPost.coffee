Template._addPost.created = ->
  @charLength = new ReactiveVar "charLength"
  @charLength.set 0

Template._addPost.rendered = ->
  $("#content").autosize()

Template._addPost.helpers
  settings: ->
    position: top
    limit: 5
    rules: [
      {
        token: "@"
        collection: Users
        field: "username"
        template: Template._userSuggestion
      }
      {
        token: "#"
        collection: Tags
        field: "tag"
        # matchAll: true
        # filter:
        #   type: autocomplete
        template: Template._tagSuggestion
      }
    ]
  charLength: ->
    return Template.instance().charLength.get()

Template._addPost.events
  "change #content, keydown #content, keyup #content, focusout #content": ->
    Template.instance().charLength.set($("#content").val().length)

  "submit form": (e, t) ->
    e.preventDefault()
    content = $("#content").val()
    Meteor.call("addPost", content, (err, res) ->
      if err
        console.log err
        return false
      else return res
    )

Router.configure(
  layoutTemplate: "layout"
  loadingTemplate: "loading"
  notFoundTemplate: "notFound"
)

Router.map ->

  @route "home",
    path: "/"
    data:
      posts: Posts.find()
    waitOn: ->
      Meteor.subscribe "posts"


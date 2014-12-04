Router.configure(
  layoutTemplate: "layout"
  loadingTemplate: "loading"
  notFoundTemplate: "notFound"
)

Router.map ->

  @route "home",
    path: "/"
    data:
      posts: Posts.find(
        {}
      ,
        sort:
          points: -1
          date: -1
      )
    waitOn: ->
      Meteor.subscribe "topPosts"

  @route "post",
    path: "l/:_id"
    data: ->
      post: Posts.findOne(@params._id)
      comments: Comments.find(postId: @params._id)
    waitOn: ->
      [
        Meteor.subscribe("post", @params._id),
        Meteor.subscribe("comments", @params._id)
      ]
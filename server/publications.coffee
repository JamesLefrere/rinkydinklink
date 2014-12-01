Meteor.publish "posts", ->
  return Posts.find()

Meteor.publish "post", (postId) ->
  check postId, String
  return Posts.find(postId)

Meteor.publish "comments", (postId) ->
  check postId, String
  return Comments.find(postId: postId)
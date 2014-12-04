Meteor.publish "posts", ->
  return Posts.find()

Meteor.publish "post", (postId) ->
  check postId, String
  return Posts.find(postId)

Meteor.publish "comments", (postId) ->
  check postId, String
  return Comments.find(postId: postId)

# Won’t scale...
Meteor.publish "usernames", ->
  return Users.find({}
  ,
    fields:
      username: 1
    limit: 5
  )

Meteor.publish "user", (username) ->
  return Users.find(
    username: username
  ,
    fields:
      username: 1
      profile: 1
  )
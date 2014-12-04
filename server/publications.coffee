Meteor.publish "topPosts", ->
  return Posts.find(
    {},
    limit: 25
    sort:
      points: -1
      date: -1
    fields:
      content: 1
      tags: 1
      username: 1
      points: 1
      upvoters: 1
      downvoters: 1
  )

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
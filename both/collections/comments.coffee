Schemas.comment = new SimpleSchema(
  postId: # Posts _id
    type: String
  userId: # Meteor.users _id
    type: String
  username:
    type: String
  date:
    type: Date
  points:
    type: Number
  upvoters:
    type: [String]
    optional: true
  downvoters:
    type: [String]
    optional: true
  body:
    type: String
    min: 2
    max: 199
)
Comments.attachSchema Schemas.comment

Meteor.methods
  addComment: (data) ->
    check @userId, String
    check data.postId, String
    check data.body, String
    user = Meteor.user()
    post = Posts.findOne(data.postId)
    if !post then throw new Meteor.Error(404, "Post not found")
    comment =
      postId: data.postId
      userId: user._id
      username: user.username
      body: data.body
      points: 0
      date: new Date()
    check comment, Schemas.comment
    return Comments.insert comment

  voteComment: (commentId, up) ->
    check @userId, String
    check commentId, String
    check up, Boolean
    comment = Comments.findOne(commentId)
    if !comment then throw new Meteor.Error(404, "Comment not found")

    upvoted = _.include comment.upvoters, @userId
    downvoted = _.include comment.downvoters, @userId

    if up
      if upvoted
        update =
          $pull: upvoters: @userId
          $inc: points: -1
      else if downvoted
        update =
          $pull: downvoters: @userId
          $addToSet: upvoters: @userId
          $inc: points: 2
      else
        update =
          $addToSet: upvoters: @userId
          $inc: points: 1
    else
      if upvoted
        update =
          $pull: upvoters: @userId
          $addToSet: downvoters: @userId
          $inc: points: -2
      else if downvoted
        update =
          $pull: downvoters: @userId
          $inc: points: 1
      else
        update =
          $addToSet: downvoters: @userId
          $inc: points: -1

    if update?
      return Comments.update({ _id: commentId }, update)

Schemas.post = new SimpleSchema(
  userId:
    type: String
  username:
    type: String
  date:
    type: Date
  tags:
    type: [String]
    minCount: 1
    maxCount: 10
  url:
    type: String
    optional: true
    max: 200
    regEx: SimpleSchema.RegEx.Url
  body:
    type: String
    optional: true
    min: 3
    max: 10000
  image:
    type: String #URL via slingshot
    optional: true
  points:
    type: Number
    defaultValue: 0
)
Posts.attachSchema Schemas.post

Meteor.methods
  addPost: (data) ->
    check @userId, String
    user = Meteor.user()

    if !data.body.length # todo: not for images
      throw new Meteor.Error(403, "No text, no post")

    if data.body.length > 120 and data.url.length
      throw new Meteor.Error(403, "Text too long for a link post")

    post =
      userId: user._id
      username: user.username
      tags: data.tags
      body: data.body
      points: 0
      date: new Date()

    if data.url.length
      post.url = data.url

    check post, Schemas.post

    return Posts.insert post
Schemas.post = new SimpleSchema(
  userId:
    type: String
  username:
    type: String
  date:
    type: Date
  type:
    type: String
    allowedValues: ["long", "link", "short"]
  tags:
    optional: true
    type: [String]
  url:
    type: String
    optional: true
    max: 200
    regEx: SimpleSchema.RegEx.Url
  content:
    type: String
    min: 3
  longContent:
    type: String
    optional: true
    max: 10000
  # image:
  #   type: String #URL via slingshot
  #   optional: true
  points:
    type: Number
  upvoters:
    type: [String]
    optional: true
  downvoters:
    type: [String]
    optional: true
)
Posts.attachSchema Schemas.post

parsePost = (content) ->
  data =
    content: content

  # A more lenient RegEx than that of SimpleSchema
  urlRegex = new RegExp(/^(^|\s)((https?:\/\/)?[\w-]+(\.[\w-]+)+\.?(:\d+)?(\/\S*)?)/gi)
  urlMatches = data.content.match(urlRegex)

  if urlMatches?.length is 1
    data.type = "link"
    data.url = urlMatches[0]
    # Remove the URL from the content and the next space
    data.content = data.content.slice(data.url.length + 1)
    # Add http if not present
    if data.url.substr(0, 4) isnt "http" then data.url = "http://" + data.url

  # Parse for tags
  tagRegex = new RegExp(/\#(\w*[a-zA-Z]+\w*)/g)
  tagMatches = data.content.match(tagRegex)
  if tagMatches?.length then data.tags = _.map(tagMatches, (tag) -> tag.slice(1))

  if content.length > 120
    data.type = "long"
    # Truncate the long post and add another field
    data.longContent = data.content
    data.content = data.content.slice(0, 120)

  else
    data.type = "short"

  # @todo: parse content for @mentions and send a notification to the user
  # mentionRegex = new RegExp(/\B\@([\w\-]+)/gim)
  # mentionMatches = content.match(mentionRegex)
  # if mentionMatches.length
  #   Meteor.call "addNotification"

  return data

Meteor.methods
  addPost: (content) ->
    check @userId, String
    user = Meteor.user()

    if !content.length # todo: not for images
      throw new Meteor.Error(403, "No text, no post")

    post = parsePost(content)
    post.userId = user._id
    post.username = user.username
    post.points = 0
    post.date = new Date()

    check post, Schemas.post

    return Posts.insert post

  votePost: (postId, up) ->
    check @userId, String
    check postId, String
    check up, Boolean
    post = Posts.findOne(postId)
    if !post then throw new Meteor.Error(404, "post not found")

    upvoted = _.include post.upvoters, @userId
    downvoted = _.include post.downvoters, @userId

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
      return Posts.update({ _id: postId }, update)
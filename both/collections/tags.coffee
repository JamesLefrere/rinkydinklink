Schemas.tag = new SimpleSchema(
  tag:
    type: String
    min: 3
    max: 100
    unique: true
)

Tags.attachSchema Schemas.tag
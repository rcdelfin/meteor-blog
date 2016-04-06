Template.blogTagList.onRendered () ->
  @autorun ->
    Meteor.subscribe 'blog.tags'


Template.blogTagList.helpers
  tagged: ->
    tag = Blog.Tag.all()
    if tag.length >= 1
      _.map tag[0].tags, (value) ->
        tag:
          value
    else
      []


# Provide data to custom templates, if any
Meteor.startup ->
  if Blog.settings.blogTagListTemplate
    customTagsList = Blog.settings.blogTagListTemplate
    Template[customTagsList].onRendered Template.blogTagList._callbacks.rendered[0]
    Template[customTagsList].helpers
      tagged: Template.blogTagList.__helpers.get('tagged')

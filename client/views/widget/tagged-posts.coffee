Template.blogTaggedPosts.onRendered () ->
  tag = if @data?.tag then @data.tag else ""
  num = if @data?.num then @data.num else 3
  @autorun ->
    Meteor.subscribe 'blog.limitedTaggedPosts', {tag: tag, num: num}


Template.blogTaggedPosts.helpers
  tagList: ->
    tag = if @tag then @tag else null
    num = if @num then @num else 3

    filters =
      mode: 'public'
    if not _.isEmpty tag
      filters = _.extend filters, {tags: tag}
    Blog.Post.find(filters,
      fields: body: 0
      sort: publishedAt: -1
      limit: num
    )

  date: (date) ->
    if date
      date = new Date(date)
      moment(date).format('MMMM Do, YYYY')


# Provide data to custom templates, if any
Meteor.startup ->
  if Blog.settings.blogTaggedPostTemplates
    _.forEach Blog.settings.blogTaggedPostTemplates, (customTagList) ->
      Template[customTagList].onRendered Template.blogTaggedPosts._callbacks.rendered[0]
      Template[customTagList].helpers
        tagList: Template.blogTaggedPosts.__helpers.get('tagList')
        date: Template.blogTaggedPosts.__helpers.get('date')

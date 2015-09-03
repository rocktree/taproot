class App.Views.GroupEditor extends Backbone.View

  el: 'body'

  events:
    'click .template-group header .actions .edit': 'editGroup'
    'click .template-group header .actions .hide': 'editGroup'

  editGroup: (e) ->
    e.preventDefault()
    if $(e.target).hasClass('edit')
      $(e.target).html('Cancel')
    else
      $(e.target).html('Edit')
    $(e.target).toggleClass('edit hide')
    header = $(e.target).parents('header')
    header.find('h3 > a').toggle()
    header.find('h3 > form').toggle()
    header.find('h3 > form input.string').focus()

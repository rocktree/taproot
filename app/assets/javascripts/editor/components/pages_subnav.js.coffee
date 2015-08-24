class App.Components.PagesSubnav extends Backbone.View

  el: 'body'

  events:
    'click #pages-subnav-trigger': 'toggleSubnav'
    'click .pages-inlist-trigger': 'toggleInlist'

  toggleSubnav: (e) ->
    e.preventDefault()
    if $(e.target).is('i')
      trigger = $(e.target).parents('#pages-subnav-trigger')
    else
      trigger = $(e.target)
    trigger.toggleClass('active')
    trigger.siblings('ul.pages').toggleClass('active')

  toggleInlist: (e) ->
    e.preventDefault()
    if $(e.target).is('i')
      trigger = $(e.target).parents('.pages-inlist-trigger')
    else
      trigger = $(e.target)
    trigger.toggleClass('active')
    trigger.siblings('ul').first().toggleClass('active')

class App.Components.DropdownMenus extends Backbone.View

  el: 'body'

  events:
    'click a.dropdown-trigger': 'toggleDropdown'

  toggleDropdown: (e) ->
    e.preventDefault()
    if $(e.target).is('a')
      $(e.target).siblings('ul').toggleClass('active')
    else
      $(e.target).parents('a').siblings('ul').toggleClass('active')
    $(e.target).toggleClass('active')

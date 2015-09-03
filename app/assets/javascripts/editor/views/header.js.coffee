class App.Views.Header extends Backbone.View

  el: '#container > header'

  events:
    'click .user-menu-trigger': 'toggleUserMenu'
    'click .site-nav-trigger': 'toggleSiteNav'

  toggleUserMenu: (e) ->
    e.preventDefault()
    $('.user > ul').toggle()

  toggleSiteNav: (e) ->
    e.preventDefault()
    $('div.site-nav').toggleClass('active')
    $(e.target).toggleClass('icon-arrow-up icon-arrow-down')

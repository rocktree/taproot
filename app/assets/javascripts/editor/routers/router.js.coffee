class App.Routers.Router extends Backbone.Router

  initialize: ->
    @loadComponents()

  loadComponents: ->
    new App.Components.Helpers
    new App.Components.DropdownMenus
    new App.Components.Modals
    new App.Components.PagesSubnav

  routes:
    ':site_uid/editor/pages/:slug/*': 'withCurrentPage'

  withCurrentPage: (site_uid, slug) ->
    new App.Views.Pages.EditHead

class App.Routers.Router extends Backbone.Router

  initialize: ->
    @loadComponents()

  loadComponents: ->
    new App.Components.Helpers
    new App.Components.DropdownMenus
    new App.Components.PagesSubnav
    new App.Components.Editor
    new App.Components.NewButton

  routes:
    ':site_uid/editor/pages': 'allPages'
    ':site_uid/editor/pages/:slug': 'pageChildren'
    ':site_uid/editor/pages/:slug/edit': 'editPage'
    ':site_uid/editor/pages/:slug/*': 'withCurrentPage'

  allPages: ->
    new App.Views.Pages.Sorter

  pageChildren: ->
    new App.Views.Pages.Sorter

  editPage: ->
    new App.Views.Pages.Blocks

  withCurrentPage: ->
    new App.Views.Pages.EditHead

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
    ':site_uid/editor/pages/:slug/meta': 'editPageMeta'

  allPages: ->
    new App.Views.Pages.Sorter

  pageChildren: ->
    new App.Views.Pages.Sorter
    new App.Views.Pages.EditHead

  editPage: ->
    new App.Views.Pages.Blocks
    new App.Views.Pages.EditHead

  editPageMeta: ->
    new App.Views.Pages.EditHead

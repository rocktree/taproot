class App.Routers.Router extends Backbone.Router

  initialize: ->
    @loadComponents()
  #   new App.Views.Header
  #   new App.Views.Shortcuts
  #   new App.Views.PickADate if $('.time-js').length > 0 || $('.date-js').length > 0
  #   new App.Views.FieldForm if $('.field-data-type').length > 0
  #   new App.Views.ImageCropper if $('.image-crop-trigger').length > 0
  #   new App.Views.DataToggle if $('.data-trigger').length > 0

  loadComponents: ->
    new App.Components.Helpers
    new App.Components.DropdownMenus
    new App.Components.Modals
    new App.Components.PagesSubnav

  routes:
    '': 'home'
  #   # Pages
  #   'sites/:site_slug/pages?*filters': 'pages'
  #   'sites/:site_slug/pages/new': 'newPage'
  #   'sites/:site_slug/pages/:page_slug?*filters': 'pages'
  #   'sites/:site_slug/pages/:page_slug/settings/:slug': 'editPage'
  #   'sites/:site_slug/pages/:page_slug/library': 'pageMedia'
  #   # Templates
  #   'sites/:site_slug/templates/:template_slug/fields': 'templateFields'
  #   # Menus
  #   'sites/:site_slug/menus/:menu_slug/items': 'menuItems'
  #   'sites/:site_slug/menus/:menu_slug/items/:item_slug': 'menuItems'
  #   # Resources
  #   'sites/:site_slug/resources/:resource_slug/fields': 'resourceFields'
  #   'sites/:site_slug/resources/:resource_slug/association_fields': 'resourceFields'
  #   # Media
  #   'sites/:site_slug/library': 'library'
  #   # Forms
  #   'sites/:site_slug/forms/:form_slug/fields': 'formFields'

  # pages: (site_slug, page_slug = null) ->
  #   new App.Views.PageSorter

  # newPage: (site_slug) ->
  #   new App.Views.MarkdownEditor
  #   new App.Views.UnloadCheck
  #   if $('.image-upload-trigger').length > 0
  #     new App.Views.PageFileUploader
  #       site: site_slug

  # editPage: (site_slug, page_slug, slug) ->
  #   new App.Views.MarkdownEditor
  #   new App.Views.UnloadCheck
  #   if $('.image-upload-trigger').length > 0
  #     new App.Views.PageFileUploader
  #       site: site_slug

  # resourceFields: (site_slug, resource_slug) ->
  #   new App.Views.ResourceFieldSorter

  # pageMedia: (site_slug, page_slug) ->
  #   new App.Views.PageMediaUploader
  #     site: site_slug
  #     page: page_slug

  # library: (site_slug) ->
  #   new App.Views.FileUploader
  #     slug: site_slug
  #   new App.Views.CropUrls
  #   new App.Views.MediaPaginator

  # templateFields: (site_slug, template_slug) ->
  #   new App.Views.FieldSorter
  #   new App.Views.GroupEditor

  # menuItems: (site_slug, menu_slug, item_slug = null) ->
  #   new App.Views.MenuItemSorter

  # formFields: (site_slug, form_slug) ->
  #   new App.Views.FormFieldSorter

class App.Routers.Router extends Backbone.Router

  initialize: ->
    @autoLoadClass()

  autoLoadClass: =>
    new App.Views.DefaultHelpers
    new App.Views.Header
    new App.Views.Tabs if $('ul.tabs').length > 0
    new App.Views.PickADate if $('.time-js').length > 0 || $('.date-js').length > 0
    new App.Views.FieldForm if $('.field-data-type').length > 0
    new App.Views.ImageCropper if $('.image-crop-trigger').length > 0

  routes:
    'sites/:site_slug/pages/new': 'newPage'
    'sites/:site_slug/pages/:page_slug/settings/:slug': 'editPage'
    'sites/:site_slug/library': 'library'

  newPage: (site_slug) ->
    if $('.image-upload-trigger').length > 0
      new App.Views.PageFileUploader
        site: site_slug

  editPage: (site_slug, page_slug, slug) ->
    new App.Views.EditorButtons
    if $('.image-upload-trigger').length > 0
      new App.Views.PageFileUploader
        site: site_slug

  library: (site_slug) ->
    new App.Views.FileUploader

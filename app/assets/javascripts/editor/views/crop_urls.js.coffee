class App.Views.CropUrls extends Backbone.View

  el: 'body'

  events:
    'focus .version-urls input[type=text]': 'selectText'
    'click a.crop-urls.link': 'toggleCropUrls'

  selectText: (e) ->
    $(e.target).select()

  toggleCropUrls: (e) ->
    e.preventDefault()
    form = $(e.target).parents('header').find('form.version-urls').first()
    form.toggle()
    form.find("input[type='text']").first().focus()


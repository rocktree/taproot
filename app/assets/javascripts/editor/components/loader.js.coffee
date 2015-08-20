class App.Components.Loader extends Backbone.View

  el: 'body'
  template: JST['editor/templates/loader']

  initialize: ->
    $(@el).prepend(@template)

  close: ->
    $(@el).find('#tk-loader').remove()

class App.Components.Editor extends Backbone.View

  initialize: ->
    for textarea in $('textarea.editor')
      $(textarea).trumbowyg()

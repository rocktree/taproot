class App.Views.MarkdownEditor extends Backbone.View

  initialize: ->
    @initEditors()

  initEditors: ->
    for textarea in $('.markdown-editor textarea')
      new Editor
        element: $(textarea)[0]

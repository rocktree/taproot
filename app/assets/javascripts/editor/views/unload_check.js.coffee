class App.Views.UnloadCheck extends Backbone.View

  el: 'body'

  events:
    'click input[type=submit]': 'submitForm'
    'change input': 'bindUnload'
    'change select': 'bindUnload'
    'change textarea': 'bindUnload'

  bindUnload: ->
    unless @bound
      @bound = true
      window.onbeforeunload = (e) ->
        e.returnValue = "Any changes you made will be lost."

  submitForm: (e) ->
    window.onbeforeunload = null
    true

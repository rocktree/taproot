class App.Components.Helpers extends Backbone.View

  el: 'body'

  initialize: =>
    @disabledLinks()
    @fadeOutNotices()

  disabledLinks: =>
    $('a.disabled').click (e) ->
      e.preventDefault()

  fadeOutNotices: =>
    setTimeout () =>
      $('.notice, .alert').fadeOut()
    , 3500

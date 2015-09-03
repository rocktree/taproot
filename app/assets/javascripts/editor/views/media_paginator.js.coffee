class App.Views.MediaPaginator extends Backbone.View

  el: 'body'

  events:
    'click nav.pagination span > a': 'loadPage'

  loadPage: (e) ->
    e.preventDefault()
    $.get $(e.target).attr('href'), (data) ->
      $('.images-container').after(data)
      $('.images-container').first().remove()
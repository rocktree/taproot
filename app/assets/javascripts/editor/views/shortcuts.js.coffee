class App.Views.Shortcuts extends Backbone.View

  el: 'body'

  shift: false

  initialize: ->
    $(document).keydown(@keydown)
    @ajaxPage = new App.Views.AjaxPage
      klass: 'media-library-viewer'

  keydown: (e) =>
    if e.altKey
      switch e.keyCode
        when 76
          @loadMediaLibrary()

  loadMediaLibrary: =>
    if @libraryTriggered
      @ajaxPage.openPage()
    else
      $.get $('body').data('library'), (data) =>
        @ajaxPage.loadContent('Media Library', data)
        @libraryTriggered = true
        new App.Views.CropUrls
        new App.Views.MediaPaginator

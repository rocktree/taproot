class App.Components.Modal extends Backbone.View

  el: 'body'
  template: JST['editor/templates/modal']

  initialize: ->
    $(@el).prepend(@template) unless $('#tk-modal').length > 0
    @modal = $('#tk-modal')

  open: (content) ->
    @modal.find('.content').html(content)
    @modal.addClass('active')
    @bindCloseEvents()

  find: (selector) ->
    @modal.find(selector)

  bindCloseEvents: ->
    @modal.find('a.close').click(@close)
    $(document).keyup (e) =>
      @close() if e.keyCode == 27
      true

  close: (e = null) =>
    e.preventDefault() if e
    @modal.removeClass('active')
    @modal.find('a.close').unbind()
    setTimeout () =>
      @modal.find('.content').html('')
    , 500

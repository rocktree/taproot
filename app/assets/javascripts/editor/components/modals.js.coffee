class App.Components.Modals extends Backbone.View

  el: 'body'
  template: JST['editor/templates/modal']

  initialize: ->
    $(@el).prepend(@template)
    @modal = $('#tk-modal')

  events:
    'click a.tk-modal-trigger': 'newModal'

  newModal: (e) ->
    e.preventDefault()
    url = $(e.target).data('modal-url')
    $.get url, (content) =>
      @openModal(content)

  openModal: (content) ->
    @modal.find('.content').html(content)
    @modal.addClass('active')
    @modal.find('form input:visible:first').focus()
    @modal.find('form').submit (e) =>
      e.preventDefault()
      loader = new App.Components.Loader
      url = @modal.find('form').attr('action')
      data = @modal.find('form').serialize()
      $.post url, data, (response) =>
        if response.split(':')[0] == 'tk-success'
          window.location.href = response.split(':')[1]
        else
          @modal.find('.content').html(response)
          loader.close()
      .fail () =>
        alert "There was a problem with your request."
        loader.close()
    @modal.find('a.close').click(@closeModal)
    $(document).keyup (e) =>
      @closeModal() if e.keyCode == 27
      true

  closeModal: (e = null) =>
    e.preventDefault() if e
    @modal.removeClass('active')
    setTimeout () =>
      @modal.find('.content').html('')
    , 500

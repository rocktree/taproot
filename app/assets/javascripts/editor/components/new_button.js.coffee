class App.Components.NewButton extends Backbone.View

  el: '#new-button-container'

  events:
    'click li > a': 'openModal'

  initialize: ->
    @modal = new App.Components.Modal

  openModal: (e) ->
    e.preventDefault()
    url = $(e.target).data('modal-url')
    $.get url, (content) =>
      @modal.open(content)
      @modal.find('input:visible:first').focus()
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

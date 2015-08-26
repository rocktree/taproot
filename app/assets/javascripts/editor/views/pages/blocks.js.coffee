class App.Views.Pages.Blocks extends Backbone.View

  el: 'div.block'

  events:
    'click #new-block': 'openModal'

  initialize: ->
    @modal = new App.Components.Modal

  openModal: (e) ->
    e.preventDefault()
    url = $(e.target).data('modal-url')
    $.get url, (content) =>
      @modal.open(content)
      @modal.find('input:visible:first').focus()
      @formListener('create')

  formListener: (step) =>
    @modal.find('form').submit (e) =>
      e.preventDefault()
      @loader = new App.Components.Loader
      url = @modal.find('form').attr('action')
      data = @modal.find('form').serialize()
      $.post(
        url, data
      ).success((response) =>
        @createSuccess(response) if step == 'create'
        @updateSuccess(response) if step == 'update'
      ).fail () =>
        alert "There was a problem with your request."
        @loader.close()

  createSuccess: (response) =>
    if response.split(':')[0] == 'tk-success'
      $.get response.split(':')[1], (html) =>
        @modal.update(html)
        @modal.find('input:visible:first').focus()
        @loader.close()
        @formListener('update')
    else
      @modal.find('.content').html(response)
      @loader.close()

  updateSuccess: (response) =>
    # TODO: Add the page to the list of pages
    @loader.close()

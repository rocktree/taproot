class App.Views.Pages.Blocks extends Backbone.View

  el: 'div.block'

  events:
    'click #new-block': 'newBlock'

  initialize: ->
    @modal = new App.Components.Modal

  newBlock: (e) ->
    e.preventDefault()
    @openModal($(e.target), 'create')

  editBlock: (e) ->
    e.preventDefault()
    @openModal($(e.target), 'update')

  openModal: (target, action) ->
    target = target.parents('a').first() unless target.is('a')
    url = target.data('modal-url')
    $.get url, (content) =>
      @modal.open(content)
      @modal.find('input:visible:first').focus()
      @formListener('create') if action == 'create'
      @formListener('update') if action == 'update'

  formListener: (step) =>
    @modal.find('form').submit (e) =>
      e.preventDefault()
      @loader = new App.Components.Loader
      url = @modal.find('form').attr('action')
      data = @modal.find('form').serialize()
      $.post(
        url, data
      ).success((response) =>
        @createSuccess(response) #if step == 'create'
        # @updateSuccess(response) if step == 'update'
      ).fail () =>
        alert "There was a problem with your request."
        @loader.close()

  createSuccess: (response) =>
    if response.split(':')[0] == 'tk-success'
      window.location.href = response.split(':')[1]
      # $.get response.split(':')[1], (html) =>
      #   @modal.update(html)
      #   @modal.find('input:visible:first').focus()
      #   @formListener('update')
    else
      @modal.find('.content').html(response)
      @loader.close()

  # updateSuccess: (response) =>
  #   if response.split(':')[0] == 'tk-success'
  #     $.get response.split(':')[1], (html) =>
  #       console.log html
  #     # TODO: Add the page to the list of pages
  #     @modal.close()
  #   else
  #     @modal.find('.content').html(response)
  #   @loader.close()

class App.Views.Pages.Blocks extends Backbone.View

  el: 'div.block'

  events:
    'click #existing-block': 'existingBlock'
    'click #new-block': 'newBlock'

  initialize: ->
    @modal = new App.Components.Modal
    @initSortable()

  existingBlock: (e) ->
    e.preventDefault()
    @openModal($(e.target), null)

  newBlock: (e) ->
    e.preventDefault()
    @openModal($(e.target), 'create')

  openModal: (target, action) ->
    target = target.parents('a').first() unless target.is('a')
    url = target.data('modal-url')
    $.get url, (content) =>
      @modal.open(content)
      @modal.find('input:visible:first').focus()
      @formListener('create') if action == 'create'

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
        @addSuccess(response) if step == 'add'
      ).fail () =>
        alert "There was a problem with your request."
        @loader.close()

  createSuccess: (response) =>
    if response.split(':')[0] == 'tk-success'
      window.location.href = response.split(':')[1]
    else
      @modal.find('.content').html(response)
      @loader.close()

  initSortable: ->
    for s in $('div.block ul')
      $(s).sortable
        handle: '.handle'
        placeholder: 'sortable-placeholder'
        toArray:
          attribute: "data-page"
        update: (e, ui) ->
          url = $(this).data('url')
          ids = $(this).sortable('toArray', { attribute: 'data-page' })
          data =
            blocks: ids
          $.post url, data, (response) =>
            return
          .fail (response) ->
            alert "Could not save block order"
          .success (response) ->
            $('body').prepend """
              <p class="notice">Block order saved</p>
            """



class App.Views.Pages.Blocks extends Backbone.View

  el: 'div.block'

  events:
    'click #new-block': 'openModal'
  #   'keyup .page-header h1': 'updateForm'
  #   'click .save-page': 'submitForm'

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
            $.get response.split(':')[1], (html) =>
              @modal.update(html)
              @modal.find('input:visible:first').focus()
              loader.close()
          else
            @modal.find('.content').html(response)
            loader.close()
        .fail () =>
          alert "There was a problem with your request."
          loader.close()

  # updateForm: (e) ->
  #   if e.keyCode == 13
  #     @submitForm(e)
  #   else
  #     @showSaveButton()
  #     $('#page_title').val($('.page-header h1 .title').html())
  #     $('#page_slug').val($('.page-header h1 .slug').html())

  # showSaveButton: ->
  #   $('.page-header a.save-page').addClass('active')

  # submitForm: (e) ->
  #   e.preventDefault()
  #   new App.Components.Loader
  #   $('.page-header form.edit_page').first().submit()

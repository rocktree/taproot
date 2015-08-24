class App.Views.Pages.EditHead extends Backbone.View

  el: 'body'

  events:
    'keyup .page-header h1': 'updateForm'
    'click .save-page': 'submitForm'

  updateForm: (e) ->
    if e.keyCode == 13
      @submitForm(e)
    else
      @showSaveButton()
      $('#page_title').val($('.page-header h1 .title').html())
      $('#page_slug').val($('.page-header h1 .slug').html())

  showSaveButton: ->
    $('.page-header a.save-page').addClass('active')

  submitForm: (e) ->
    e.preventDefault()
    new App.Components.Loader
    $('.page-header form.edit_page').first().submit()

class App.Views.Pages.EditTitle extends Backbone.View

  el: 'body'

  events:
    'keyup .page-header h1': 'updateForm'
    'click .save-page': 'submitForm'

  initialize: ->
    console.log '123'

  updateForm: (e) ->
    if e.keyCode == 13
      @submitForm(e)
    else
      @showSaveButton()
      $('#page_title').val($('.page-header h1').html())

  showSaveButton: ->
    $('.page-header a.save-page').addClass('active')

  submitForm: (e) ->
    e.preventDefault()
    new App.Components.Loader
    $('.page-header form.edit_page').first().submit()

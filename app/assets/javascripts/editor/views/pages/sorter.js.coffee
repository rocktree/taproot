class App.Views.Pages.Sorter extends Backbone.View

  el: 'body'

  initialize: ->
    @initPageSort()

  initPageSort: ->
    sortable = $('table tbody').sortable
      helper: fixHelper
      placeholder: 'sortable-placeholder'
      toArray:
        attribute: "data-page"
      update: (e, ui) ->
        pages = $(this).sortable('toArray', { attribute: 'data-page' })
        $('input#reorder_pages').val(pages)
        $('.simple_form.reorder input[type=submit]').addClass('active')

  fixHelper = (e, ui) ->
    ui.children().each ->
      $(this).width $(this).width()
      return
    ui


class App.Views.Pages.Sorter extends Backbone.View

  el: 'body'
  s: $('table tbody')

  events:
    'click a.sort-mode': 'toggleSortMode'
    'click a.save-order': 'submitForm'

  initialize: ->
    @initPageSort()
    @s.sortable('disable')

  initPageSort: ->
    @s.sortable
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

  submitForm: (e) ->
    $('.simple_form.reorder').submit()

  toggleSortMode: (e) ->
    e.preventDefault()
    if $(e.target).is('i')
      a = $(e.target).parents('a').first()
    else
      a = $(e.target)
    a.siblings('.save-order').addClass('active')
    if a.hasClass('reorder')
      if a.hasClass('active')
        @s.sortable('disable')
        a.removeClass('active')
      else
        @s.sortable('enable')
        a.addClass('active')
    else if a.hasClass('nest')
      @s.sortable('disable')
      a.siblings('.sort-mode.reorder').removeClass('active')

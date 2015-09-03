class App.Views.DataToggle extends Backbone.View

  el: 'body'

  events:
    'click a.data-trigger': 'toggleDataTable'

  initialize: ->
    $('a.data-trigger').parents('.data-container').find('.data-table')
      .addClass('active')
    $('a.data-trigger').addClass('active')

  toggleDataTable: (e) ->
    e.preventDefault()
    $(e.target).toggleClass('active')
    $(e.target).parents('.data-container').find('.data-table')
      .toggleClass('active')

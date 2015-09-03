class App.Views.FieldForm extends Backbone.View

  el: 'body'

  events:
    'change .field-data-type': 'fieldChange'

  initialize: ->
    for option in $('form').find('.field-options')
      val = $(option).parents('.field').find('select.field-data-type').val()
      @toggleOptions(val, $(option))

  fieldChange: (e) ->
    val = $(e.target).find('option:selected').val()
    options = $(e.target).parents('.field').find('.field-options')
    @toggleOptions(val, options)

  toggleOptions: (val, options) ->
    options.hide()
    if val in ['select', 'check_boxes', 'radio_buttons']
      options.css('display','inline-block')

class App.Views.PickADate extends Backbone.View

  el: 'body'

  initialize: ->
    $('.date-js').pickadate
      format: 'yyyy.mm.dd'
    $('.time-js').pickatime()

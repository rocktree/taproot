class App.Views.AjaxPage extends Backbone.View

  el: 'body'

  template: JST['builder/templates/ajax_page']

  initialize: (options) ->
    guid = @guid()
    $('body').append(@template(klass: guid, id: options.klass))
    @page = $(".ajax-page.#{guid}").first()
    $(document).on 'keyup', (e) =>
      @closePage() if e.keyCode == 27

  loadContent: (title, content) ->
    $(@page).find('header > .title').html(title)
    $(@page).find('.ajax-page-content').html(content)
    $(@page).addClass('active')
    @lockScrolling()
    $(@page).find('header a.close').click (e) =>
      e.preventDefault()
      @closePage()
      @unlockScrolling()

  clearContent: ->
    $(@page).html('')

  openPage: ->
    $(@page).addClass('active')
    @lockScrolling()

  closePage: ->
    $(@page).removeClass('active')
    @unlockScrolling()

  guid: ->
     "#{parseInt(Date.now())}-#{parseInt(Math.random() * 1000000)}"

  lockScrolling: ->
    $('body').css
      overflow: 'hidden'
      height: '100%'

  unlockScrolling: ->
    $('body').css
      overflow: 'auto'
      height: 'auto'

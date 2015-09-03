class App.Views.PageFileUploader extends Backbone.View

  el: 'body'
  triggered: false

  events:
    'click .image-upload-trigger': 'triggerUploader'
    'click .remove-file': 'removeFile'

  initialize: (options) ->
    @site = options.site
    $.get "/sites/#{options.site}/library/max_file_size.json", (data) =>
      @maxFileSize = parseFloat(data)
    @ajaxPage = new App.Views.AjaxPage
      klass: 'page-file-uploader'

  removeFile: (e) ->
    e.preventDefault()
    container = $(e.target).parents('.upload-field')
    container.find('input').val('')
    container.find('img').remove()

  triggerUploader: (e) ->
    e.preventDefault()
    @container = $(e.target).parents('.upload-field')
    if @triggered
      @ajaxPage.openPage()
    else
      $.get $(e.target).attr('href'), (data) =>
        @ajaxPage.loadContent('Add File', data)
        $('.image a.select').click(@selectImage)
        @initUploader()
        @triggered = true

  selectImage: (e) =>
    e.preventDefault()
    idx = $(e.target).parents('article.image').attr('data-idx')
    thumb = $(e.target).parents('article.image').find('img').attr('src')
    @container.find('input').val(idx)
    @container.prepend('<img>') unless @container.find('img').length > 0
    @container.find('img').attr('src', thumb)
    @ajaxPage.closePage()

  # This can be refactored. It shares much with image_uploader.js.coffee
  #
  # The big difference is it rebinds the click events after the file is
  # uploaded.
  #
  initUploader: =>
    $('.upload-trigger').click (e) ->
      e.preventDefault()
      $('#fileupload').find('#file').click()
    $('#fileupload').fileupload
      add: (e, data) =>
        types = /(\.|\/)(gif|jpe?g|png|pdf)$/i
        file = data.files[0]
        kb = file.size / 1000
        mb = kb / 1000
        if (types.test(file.type) || types.test(file.name)) && mb <= @maxFileSize
          data.context = $(tmpl("template-upload", file))
          $('section.images-container').before(data.context)
          data.submit()
        else if mb > @maxFileSize
          alert "File must be less than #{@maxFileSize} MB."
        else
          alert "File must be an image or a PDF."
      progress: (e, data) ->
        if data.context
          progress = parseInt(data.loaded / data.total * 100, 10)
          data.context.find('.bar').css('width', progress + '%')
      done: (e, data) =>
        data.context.remove()
        $.get $('#fileupload').data('reload-url'), (data) =>
          $('section.images-container').html(data)
          $('.image a.select').click(@selectImage)
      fail: (e, data) ->
        alert "There was an error with your upload."
        data.context.remove()


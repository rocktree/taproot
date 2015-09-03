class App.Views.FileUploader extends Backbone.View

  el: 'body'

  events:
    'click .upload-trigger': 'toggleForm'

  initialize: (options) ->
    $.get "/sites/#{options.slug}/library/max_file_size.json", (data) =>
      @maxFileSize = parseFloat(data)
    @initUploader()

  initUploader: ->
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
      done: (e, data) ->
        data.context.remove()
        $.get $('#fileupload').data('reload-url'), (data) ->
          $('section.images-container').html(data)
      fail: (e, data) ->
        alert "There was an error with your upload."
        data.context.remove()

  toggleForm: (e) ->
    e.preventDefault()
    $('#fileupload').find('#file').click()

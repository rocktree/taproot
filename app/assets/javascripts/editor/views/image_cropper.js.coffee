class App.Views.ImageCropper extends Backbone.View

  el: 'body'

  events:
    'click .image-crop-trigger': 'showModal'

  initialize: ->
    @ajaxPage = new App.Views.AjaxPage
      klass: 'image-cropper'

  showModal: (e) ->
    e.preventDefault()
    $.get $(e.target).attr('href'), (data) =>
      @ajaxPage.loadContent('Crop Image', data)
      for container in $('.ajax-page-content').find('section.cropper')
        @initCropper($(container))

  initCropper: (container) ->
    img = container.find('img').first()
    img.on 'load', () =>
      c = @getFormCoords(container)
      x = c.x * (img.width() / container.data('img-width'))
      y = c.y * (img.height() / container.data('img-height'))
      @cropper = img.Jcrop
        aspectRatio: container.data('ratio')
        setSelect: [
          x,
          y,
          x + (c.w * (img.width() / container.data('img-width'))),
          y + (c.h * (img.height() / container.data('img-height')))
        ]
        onSelect: (coords) =>
          @setFormCoords(coords, img, container)
        onChange: (coords) =>
          @setFormCoords(coords, img, container)

  setFormCoords: (coords, img, parent) ->
    prefix = "#document_crop_data_#{parent.data('slug')}"
    if coords.w == 0
      $("#{prefix}_x").val($("#{prefix}_x").data('value'))
      $("#{prefix}_y").val($("#{prefix}_y").data('value'))
      $("#{prefix}_crop_width").val($("#{prefix}_crop_width").data('value'))
      $("#{prefix}_crop_height").val($("#{prefix}_crop_height").data('value'))
    else
      $("#{prefix}_x").val        coords.x / img.width() * parent.data('img-width')
      $("#{prefix}_y").val        coords.y / img.height() * parent.data('img-height')
      $("#{prefix}_crop_width").val    coords.w / img.width() * parent.data('img-width')
      $("#{prefix}_crop_height").val   coords.h / img.height() * parent.data('img-height')

  getFormCoords: (parent) ->
    prefix = "#document_crop_data_#{parent.data('slug')}"
    coords =
      x: parseFloat($("#{prefix}_x").val())
      y: parseFloat($("#{prefix}_y").val())
      w: parseFloat($("#{prefix}_crop_width").val())
      h: parseFloat($("#{prefix}_crop_height").val())

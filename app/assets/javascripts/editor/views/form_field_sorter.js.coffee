class App.Views.FormFieldSorter extends Backbone.View

  el: 'body'

  initialize: ->
    @initFieldSort()

  initFieldSort: ->
    for section in $('.data-table')
      sortable = $(section).sortable
        placeholder: 'sortable-placeholder'
        toArray:
          attribute: "data-id"
        update: (e, ui) ->
          ids = $(this).sortable('toArray', { attribute: 'data-id' })
          for id, idx in ids
            if id
              form = $("article.form-field[data-id='#{id}']")
                .find('form.field-position')
                .first()
              if parseInt(form.find('input.position').first().val()) != idx
                form.find('input.position').first().val(idx)
                $.ajax
                  type: "PATCH",
                  url: form.attr('action'),
                  data: form.serialize(),
                  dataType: 'json'

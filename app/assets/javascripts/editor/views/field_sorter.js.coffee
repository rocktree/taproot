class App.Views.FieldSorter extends Backbone.View

  el: 'body'

  initialize: ->
    @initGroupSort()
    @initFieldSort()

  initGroupSort: ->
    for group in $('#page-content')
      sortable = $(group).sortable
        toArray:
          attribute: "data-id"
        stop: (e, ui) ->
          ids = $(this).sortable('toArray', { attribute: 'data-id' })
          for id, idx in ids
            form = $("article.template-group[data-id='#{id}']")
              .find('form.group-position').first()
            unless parseInt(form.find('input.position').first().val()) == idx
              form.find('input.position').first().val(idx)
              $.ajax
                type: "PATCH",
                url: form.attr('action'),
                data: form.serialize(),
                dataType: 'json'

  initFieldSort: ->
    for section in $('.data-table')
      sortable = $(section).sortable
        connectWith: '.data-table'
        placeholder: 'sortable-placeholder'
        toArray:
          attribute: "data-id"
        create: (e, ui) ->
          ids = $(this).sortable('toArray', { attribute: 'data-id' })
          if ids.length > 1
            $(this).siblings('header').find('a.delete').hide()
          else
            $(this).siblings('header').find('a.delete').show()
        update: (e, ui) ->
          ids = $(this).sortable('toArray', { attribute: 'data-id' })
          if ids.length > 1
            $(this).siblings('header').find('a.delete').hide()
          else
            $(this).siblings('header').find('a.delete').show()
          for id, idx in ids
            if id
              form = $("article.form-field[data-id='#{id}']")
                .find('form.field-position').first()
              groupID = form.parents('article.template-group').first()
                .attr('data-id')
              if(
                parseInt(form.find('input.position').first().val()) != idx ||
                parseInt(form.find('input.group-id').first().val()) != groupID
              )
                form.find('input.position').first().val(idx)
                form.find('input.group-id').first().val(groupID)
                $.ajax
                  type: "PATCH",
                  url: form.attr('action'),
                  data: form.serialize(),
                  dataType: 'json'

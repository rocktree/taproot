class App.Views.MenuItemSorter extends Backbone.View

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
              form = $("article.menu-item[data-id='#{id}']")
                .find('form.item-position')
                .first()
              if parseInt(form.find('input.position').first().val()) != idx
                form.find('input.position').first().val(idx)
                $.ajax
                  type: "PATCH",
                  url: form.attr('action'),
                  data: form.serialize(),
                  dataType: 'json'

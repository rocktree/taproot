class App.Views.PageSorter extends Backbone.View

  el: 'body'

  initialize: ->
    if $('#page-content').data('sortable') == true
      @initPageSort()

  initPageSort: ->
    sortable = $('.data-table').first().sortable
      placeholder: 'sortable-placeholder'
      toArray:
        attribute: "data-id"
      update: (e, ui) ->
        ids = $(this).sortable('toArray', { attribute: 'data-id' })
        for id, idx in ids
          if id
            form = $("article.page[data-id='#{id}']")
              .find('form.page-position')
              .first()
            if parseInt(form.find('input.position').first().val()) != idx
              form.find('input.position').first().val(idx)
              $.ajax
                type: "PATCH",
                url: form.attr('action'),
                data: form.serialize(),
                dataType: 'json'

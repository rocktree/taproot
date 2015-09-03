class App.Views.Pages.Sorter extends Backbone.View

  el: 'body'
  s: $('table tbody')

  events:
    'click a.sort-mode': 'toggleSortMode'
    'click a.save-order': 'submitForm'

  initialize: ->
    @initPageSort()
    @s.sortable('disable')
    @initPageNest()
    interact('.draggable').draggable(false)

  initPageSort: ->
    @s.sortable
      helper: fixHelper
      placeholder: 'sortable-placeholder'
      toArray:
        attribute: "data-page"
      update: (e, ui) ->
        $('.page-header').find('a.save-order').addClass('active')
        pages = $(this).sortable('toArray', { attribute: 'data-page' })
        $('input#reorder_pages').val(pages)
        $('.simple_form.reorder input[type=submit]').addClass('active')

  fixHelper = (e, ui) ->
    ui.children().each ->
      $(this).width $(this).width()
      return
    ui

  initPageNest: ->
    dragMoveListener = (event) ->
      target = event.target
      x = (parseFloat(target.getAttribute('data-x')) or 0) + event.dx
      y = (parseFloat(target.getAttribute('data-y')) or 0) + event.dy
      # translate the element
      target.style.webkitTransform =
        target.style.transform = "translate(#{x}px, #{y}px)"
      # update the posiion attributes
      target.setAttribute 'data-x', x
      target.setAttribute 'data-y', y
      $(target).addClass('dragging')
      return

    interact('.draggable').draggable
      inertia: true
      restrict:
        restriction: 'parent'
        endOnly: true
        elementRect:
          top: 0
          left: 0
          bottom: 1
          right: 1
      onmove: dragMoveListener
      onend: (event) ->
        target = event.target
        x = 0
        y = 0
        # translate the element
        target.style.webkitTransform =
          target.style.transform = "translate(#{x}px, #{y}px)"
        # update the posiion attributes
        target.setAttribute 'data-x', x
        target.setAttribute 'data-y', y
        $(target).removeClass('dragging')
        return

    interact('.droppable').dropzone
      accept: '.draggable'
      overlap: 0.01
      ondragenter: (e) ->
        $(e.target).addClass('drop-target')
      ondragleave: (e) ->
        $(e.target).removeClass('drop-target')
      ondrop: (e) ->
        $(e.target).removeClass('drop-target')
        id = $(e.target).data('page-id')
        $(e.relatedTarget).find('input.parent').val(id)
        loader = new App.Components.Loader
        form = $(e.relatedTarget).find('form')
        $.post form.attr('action'), form.serialize(), (data) =>
          loader.close()
        .success () =>
          $(e.relatedTarget).remove()
        .fail () =>
          alert "There was an error nesting this page."
          loader.close()

  toggleSortMode: (e) ->
    e.preventDefault()
    if $(e.target).is('i')
      a = $(e.target).parents('a').first()
    else
      a = $(e.target)
    tbody = $('table.pages tbody')
    # reorder click
    if a.hasClass('reorder')
      interact('.draggable').draggable(false)
      tbody.removeClass('icon-lock')
      a.siblings('.sort-mode.nest').removeClass('active')
      if a.hasClass('active')
        @s.sortable('disable')
        tbody.removeClass('icon-lock')
        a.removeClass('active')
      else
        @s.sortable('enable')
        tbody.addClass('icon-lock')
        a.addClass('active')
    # nest click
    else if a.hasClass('nest')
      @s.sortable('disable')
      tbody.removeClass('icon-lock')
      a.siblings('.sort-mode.reorder').removeClass('active')
      if a.hasClass('active')
        interact('.draggable').draggable(false)
        tbody.removeClass('icon-lock')
        a.removeClass('active')
      else
        interact('.draggable').draggable(true)
        tbody.addClass('icon-lock')
        a.addClass('active')

  submitForm: (e) ->
    $('.simple_form.reorder').submit()

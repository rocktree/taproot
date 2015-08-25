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
        return
      #   textEl = event.target.querySelector('p')
      #   textEl and (textEl.textContent = 'moved a distance of ' + (Math.sqrt(event.dx * event.dx + event.dy * event.dy) | 0) + 'px')
      #   return
    # this is used later in the resizing demo
    # window.dragMoveListener = dragMoveListener
    # d = interact('.draggable').draggable
    #   inertia: true
    #   restrict:
    #     restriction: 'parent'
    #     endOnly: true
    #     elementRect:
    #       top: 0
    #       left: 0
    #       bottom: 1
    #       right: 1

    interact('.draggable').dropzone
      accept: '.draggable'
      overlap: 0.5
    #   ondropactivate: (event) ->
    #     # add active dropzone feedback
    #     event.target.classList.add 'drop-active'
    #     return
      ondragenter: (e) ->
    #     draggableElement = event.relatedTarget
    #     # feedback the possibility of a drop
        $(e.target).addClass('drop-target')
    #     draggableElement.classList.add 'can-drop'
    #     draggableElement.textContent = 'Dragged in'
    #     return
      ondragleave: (e) ->
    #     # remove the drop feedback style
        $(e.target).removeClass('drop-target')
        # event.relatedTarget.classList.remove 'can-drop'
    #     event.relatedTarget.textContent = 'Dragged out'
    #     return
      ondrop: (e) ->
        $(e.target).removeClass('drop-target')
        id = $(e.target).data('page-id')
        $(e.relatedTarget).find('input.parent').val(id)
        loader = new App.Components.Loader
        form = $(e.relatedTarget).find('form')
        $.post form.attr('action'), form.serialize()
        .success () =>
          $(e.relatedTarget).remove()
          loader.close()
        .fail () =>
          loader.close()
          alert "There was an error nesting this page."
          # window.reload
    #     event.relatedTarget.textContent = 'Dropped'
    #     return
    #   ondropdeactivate: (event) ->
    #     # remove active dropzone feedback
    #     event.target.classList.remove 'drop-active'
    #     event.target.classList.remove 'drop-target'
    #     return

  toggleSortMode: (e) ->
    e.preventDefault()
    if $(e.target).is('i')
      a = $(e.target).parents('a').first()
    else
      a = $(e.target)
    a.siblings('.save-order').addClass('active')
    # reorder click
    if a.hasClass('reorder')
      interact('.draggable').draggable(false)
      a.siblings('.sort-mode.nest').removeClass('active')
      if a.hasClass('active')
        @s.sortable('disable')
        a.removeClass('active')
      else
        @s.sortable('enable')
        a.addClass('active')
    # nest click
    else if a.hasClass('nest')
      @s.sortable('disable')
      a.siblings('.sort-mode.reorder').removeClass('active')
      if a.hasClass('active')
        interact('.draggable').draggable(false)
        a.removeClass('active')
      else
        interact('.draggable').draggable(true)
        a.addClass('active')

  submitForm: (e) ->
    $('.simple_form.reorder').submit()

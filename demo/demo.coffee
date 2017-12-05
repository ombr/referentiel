$ ->
  parse_assert = (input)->
    $.map input.split(':'), (i)->
      [
        $.map i.split(','), (s)->
          parseFloat(s)
      ]
  add_marker = (point)->
    $marker = $('<div class="marker"></div>')
    $marker.css('top', point[1]-5)
    $marker.css('left', point[0]-5)
    $marker.attr('data-x', point[0])
    $marker.attr('data-y', point[1])
    $('body').append($marker)

  $('.referentiel').each ->
    ref = new Referentiel(this)
    $('[data-assert]', this).each (assert)->
      [global, local] = parse_assert $(this).data('assert')
      result = ref.global_to_local(global)
      console.log this, global, result, local
      add_marker(global)
      $assert = $(this)
      $assert.css('left', result[0]-3)
      $assert.css('top', result[1]-3)
      $assert.attr('cx', result[0])
      $assert.attr('cy', result[1])
      $assert.data('x', result[0])
      $assert.data('y', result[1])

  $('body').on 'click', (e)->
    $('.referentiel').each ->
      ref = new Referentiel(this)
      input = [e.pageX, e.pageY]
      p = ref.global_to_local(input)
      if $('.pointer', this).length == 0
        $pointer = $('<div class="pointer"></div>')
        $(this).append($pointer)
      $pointer = $('.pointer', this)
      console.log input, '->', p
      $pointer.css('left', p[0]-3)
      $pointer.css('top', p[1]-3)
      $pointer.attr('cx', p[0])
      $pointer.attr('cy', p[1])

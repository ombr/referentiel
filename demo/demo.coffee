$ ->
  $('.referentiel').each ->
    console.log this
    ref = new Referentiel(this)
    $(this).on 'click', (e)->
      input = [e.pageX, e.pageY]
      p = ref.global_to_local(input)
      console.log input, '->', p
      $pointer = $('.pointer', this)
      $pointer.css('left', p[0]-1)
      $pointer.css('top', p[1]-1)

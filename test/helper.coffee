dom = (e)->
  el = $(e)
  $('body').append(el)
  el[0]
from_template = (template)->
  $context = $('<div style="position: fixed; top: 0; left: 0">'+template+'</div>')
  $('body').append($context)
  ref = new Referentiel(
    $('.reference', $context)[0],
    $('.context', $context)[0]
  )

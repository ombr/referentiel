dom = (e)->
  el = $(e)
  $('body').append(el)
  el[0]
from_template = (template)->
  $context = $(template)
  $('body').append($context)
  ref = new Referentiel(
    $('.reference', $context)[0],
    $('.context', $context)[0]
  )

# afterEach ->
#   console.log 'CLEAR'
#   $('body').html('')

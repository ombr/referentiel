load_template = (template_name, callback)->
  $.get
    url: '/base/test/'+template_name+'.html',
    dataType: 'text'
    success: callback
parse_assert = (input)->
  $.map input.split(':'), (i)->
    [
      $.map i.split(','), (s)->
        parseFloat(s)
    ]
describe "Referentiel", ->
  run_test_from_template = (template_name, callback)->
    load_template template_name, (template)->
      $context = $('<div style="position: fixed; top: 0; left: 0">'+template+'</div>')
      $('body').append($context)
      $('.referentiel', $context).each ->
        referentiel = new Referentiel(this)
        $('[data-assert]', this).each (assert)->
          [global, local] = parse_assert $(this).data('assert')
          round = (value)->
            Math.round(value*1000)/1000
          result = referentiel.global_to_local(global)
          result = [round(result[0]), round(result[1])]
          # console.log 'assert', global, local, result, referentiel.local_to_global(local)
          expect(result).toEqual(local)
      callback()
  add_test = (template_name)->
    it template_name, (done)->
      run_test_from_template template_name, done
  for template_name in [
    'borders'
    'margins'
    'rotation-transform-origin',
    'rotation-transform-origin',
    'position-offset',
    'position-in-flow',
    'rotation',
    'rotation-scale',
    'svg-basic',
    'svg-viewport',
    'svg-margin',
    'svg-border',
    'svg-no-viewbox',
    'svg-composition',
    'position-basique',
    'position-scoped',
    # 'svg-group',
  ]
    add_test(template_name)

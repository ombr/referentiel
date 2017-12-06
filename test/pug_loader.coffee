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
describe "Pug", ->
  run_test_from_template = (template_name, callback)->
    load_template template_name, (template)->
      $context = $('<div style="position: fixed; top: 0; left: 0">'+template+'</div>')
      $('body').append($context)
      $('.referentiel', $context).each ->
        referentiel = new Referentiel(this)
        $('[data-assert]', this).each (assert)->
          [global, local] = parse_assert $(this).data('assert')
          result = referentiel.global_to_local(global)
          expect(result).toEqual(local)
      callback()
  add_test = (template_name)->
    it template_name, (done)->
      run_test_from_template template_name, done
  for template_name in [
    'svg-1',
    'svg-2',
    'svg-3',
    'svg-4',
    'position-basique',
    'position-scoped',
  ]
    add_test(template_name)

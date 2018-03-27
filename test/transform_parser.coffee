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
describe "Transform parser", ->
  run_test_from_template = (template_name, callback)->
    load_template template_name, (template)->
      $context = $('<div>'+template+'</div>')
      $('body').append($context)
      $('.transform-parser', $context).each ->
        console.log this
        # input = $(this).css('transform')
        input = this.style.transform
        browserComputed = window.getComputedStyle(this).getPropertyValue('transform')
        output = $(this).data('expected') || browserComputed
        result = Referentiel.TransformParser.parse(input)
        console.log 'ICI', input, result, output
        expect(result).toEqual(output)
      callback()
  add_test = (template_name)->
    fit template_name, (done)->
      run_test_from_template template_name, done
  for template_name in [
    'transform_parser'
  ]
    add_test(template_name)

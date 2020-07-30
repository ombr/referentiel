var loadTemplate, parseAssert
var $ = window.$
var Referentiel = window.Referentiel
var it = window.it
var describe = window.describe
var expect = window.expect

loadTemplate = function (templateName, callback) {
  return $.get({
    url: '/base/test/' + templateName + '.html',
    dataType: 'text',
    success: callback
  })
}

parseAssert = function (input) {
  return $.map(input.split(':'), function (i) {
    return [
      $.map(i.split(','),
        function (s) {
          return parseFloat(s)
        })
    ]
  })
}

describe('Pug', function () {
  var addTest, j, len, ref, results, runTestFromTemplate, templateName
  runTestFromTemplate = function (templateName, callback) {
    return loadTemplate(templateName, function (template) {
      var $context
      $context = $('<div style="position: fixed; top: 0; left: 0">' + template + '</div>')
      $('body').append($context)
      $('.referentiel', $context).each(function () {
        var referentiel
        referentiel = new Referentiel.Referentiel(this)
        return $('[data-assert]', this).each(function (assert) {
          var result, round
          var parsed = parseAssert($(this).data('assert'))
          var global = parsed[0]
          var local = parsed[1]
          round = function (value) {
            return Math.round(value * 1000) / 1000
          }
          result = referentiel.convertPointFromPageToNode(global)
          result = [round(result[0]), round(result[1])]
          // console.log('assert', global, local, result, referentiel.localToGlobal(local));
          return expect(result).toEqual(local)
        })
      })
      return callback()
    })
  }
  addTest = function (templateName) {
    return it(templateName, function (done) {
      return runTestFromTemplate(templateName, done)
    })
  }
  ref = ['basic', 'borders', 'margins', 'margins2', 'padding', 'rotation-transform-origin', 'rotation-transform-origin', 'position-offset', 'position-in-flow',
    'rotation', 'rotation-scale', 'svg-basic', 'svg-viewport', 'svg-margin', 'svg-border', 'svg-no-viewbox', 'svg-composition',
    'position-basique', 'position-scoped', 'fixed', 'fixed_offset', 'absolute', 'absolute_tricky', 'absolute_stacked', 'absolute_transformations']
  results = []
  for (j = 0, len = ref.length; j < len; j++) {
    templateName = ref[j]
    // 'svg-group',
    results.push(addTest(templateName))
  }
  return results
})

var $ = window.$
console.log('HEY HEY');
var Referentiel = window.Referentiel
$(function () {
  var addMarker, parseAssert
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
  addMarker = function (point) {
    var $marker
    $marker = $('<div class="marker"></div>')
    console.log('ICIC !')
    $marker.css('top', point[1] - 5)
    $marker.css('left', point[0] - 5)
    $marker.attr('data-x', point[0])
    $marker.attr('data-y', point[1])
    return $('body').append($marker)
  }
  $('.referentiel').each(function () {
    var ref = new Referentiel.Referentiel(this)
    return $('[data-assert]', this).each(function (assert) {
      var $assert, result
      var parsed = parseAssert($(this).data('assert'))
      var global = parsed[0]
      var local = parsed[1]
      result = ref.globalToLocal(global)
      console.log(this, global, result, local)
      addMarker(global)
      $assert = $(this)
      $assert.css('left', result[0] - 3)
      $assert.css('top', result[1] - 3)
      $assert.attr('cx', result[0])
      $assert.attr('cy', result[1])
      $assert.data('x', result[0])
      return $assert.data('y', result[1])
    })
  })
  return $('body').on('click', function (e) {
    return $('.referentiel').each(function () {
      var $pointer, input, p, ref
      ref = new Referentiel.Referentiel(this)
      input = [e.pageX, e.pageY]
      p = ref.globalToLocal(input)
      if ($('.pointer', this).length === 0) {
        $pointer = $('<div class="pointer"></div>')
        $(this).append($pointer)
      }
      $pointer = $('.pointer', this)
      console.log('======')
      console.log(input, '->', p, new Referentiel.Referentiel(this).matrix(), this)
      $pointer.css('left', p[0] - 3)
      $pointer.css('top', p[1] - 3)
      $pointer.attr('cx', p[0])
      return $pointer.attr('cy', p[1])
    })
  })
})

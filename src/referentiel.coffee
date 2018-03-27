MatrixUtils = require('./matrix_utils.coffee')
module.exports = class Referentiel
  constructor: (@reference, @options = {})->
  global_to_local: (point)->
    @_multiplyPoint(@matrixInv(), point)
  local_to_global: (point)->
    @_multiplyPoint(@matrix(), point)
  _multiplyPoint: (matrix, point)->
    v = [point[0], point[1], 1]
    res = MatrixUtils.multVector(matrix, v)
    [ @_export(res[0]), @_export(res[1]) ]
  _export: (value)->
    res = @_round(value)
    return 0 if res == -0
    res
  _round: (value)->
    precision = 1000000.0
    Math.round(precision*value)/precision
  clear_cache: ->
    delete @_matrixInv
    delete @_matrix
    delete @_matrixTransform
    delete @_matrixTransformOrigin
    delete @_matrixSVG
  matrixInv: ->
    return @_matrixInv if @_matrixInv
    @_matrixInv = @matrixInv_compute()
    @_matrixInv
  matrixInv_compute: ->
    MatrixUtils.inv(@matrix())
  matrix: ->
    return @_matrix if @_matrix
    @_matrix = @matrixCompute()
    @_matrix
  matrixCompute: ->
    matrixLocale = @matrixLocale()
    if @css('position') == 'fixed'
      return matrixLocale
    parent = @parent()
    if parent
      return MatrixUtils.mult(
        (new Referentiel(
          parent,
          offsetParent: @reference.offsetParent
        )).matrix(),
        matrixLocale
      )
    matrixLocale
  matrixLocale: ->
    return @_matrixLocale if @_matrixLocale
    @_matrixLocale = @matrixLocaleCompute()
    @_matrixLocale
  matrixLocaleCompute: ->
    MatrixUtils.mult(
      @matrixSVGViewbox(),
      @matrixOffset(),
      @matrixTransformOrigin(),
      @matrixTransform(),
      MatrixUtils.inv(@matrixTransformOrigin()),
      @matrixBorder()
    )

  matrixTransform: ->
    return @_matrixTransform if @_matrixTransform
    @_matrixTransform = @matrixTransformCompute()
    @_matrixTransform
  matrixTransformCompute: ->
    transform = @reference.getAttribute('transform') || 'none'
    transform = @reference.style.transform unless transform.match(/^matrix\((.*)\)$/)
    transform = @css('transform') unless transform.match(/^matrix\((.*)\)$/)
    if res = transform.match(/^matrix\((.*)\)$/)
      floats = res[1].replace(',', ' ').replace('  ', ' ').split(' ').map((e)->
        parseFloat(e)
      )
      return [[floats[0], floats[2], floats[4]],[floats[1], floats[3], floats[5]], [0, 0, 1]]
    [[1,0,0], [0,1,0], [0,0,1]]

  matrixTransformOrigin: ->
    return @_matrixTransformOrigin if @_matrixTransformOrigin
    @_matrixTransformOrigin = @matrixTransformOriginCompute()
    @_matrixTransformOrigin

  matrixTransformOriginCompute: ->
    transform_origin = @css('transform-origin').replace(/px/g, '').split(' ').map (v)->
      parseFloat(v)
    [[1,0, transform_origin[0]], [0, 1, transform_origin[1]],[0,0,1]]

  matrixBorder: ->
    return @_matrixBorder if @_matrixBorder
    @_matrixBorder = @matrixBorderCompute()
    @_matrixBorder
  matrixBorderCompute: ->
    left = parseFloat(@css('border-left-width').replace(/px/g, '') || 0)
    top = parseFloat(@css('border-top-width').replace(/px/g, '') || 0)
    [[1,0,left],[0,1,top],[0,0,1]]

  matrixOffset: ->
    return @_matrixOffset if @_matrixOffset
    @_matrixOffset = @matrixOffsetCompute()
    @_matrixOffset
  parent: (element)->
    element ||= @reference
    if element.parentNode? && element.parentNode != document.documentElement
      element.parentNode
    else
      null
  matrixOffsetCompute: ->
    [left, top] = @offset()
    switch @css('position')
      when 'absolute'
        return [[1,0,left],[0,1,top],[0,0,1]]
      when 'fixed'
        left += window.pageXOffset
        top += window.pageYOffset
        return [[1,0,left],[0,1,top],[0,0,1]]
    if @options.offsetParent?
      if @options.offsetParent != @reference
        [left, top] = [0, 0]
    [[1,0,left],[0,1,top],[0,0,1]]
  matrixSVGViewbox: ->
    return @_matrix_viewbox_svg if @_matrixSVGViewbox
    @_matrixSVGViewbox = @matrixSVGViewboxCompute()
    @_matrixSVGViewbox
  matrixSVGViewboxCompute: ->
    return [[1,0,0], [0,1,0], [0,0,1]] unless @reference instanceof SVGElement
    size = [
      parseFloat(@css('width').replace(/px/g, ''))
      parseFloat(@css('height').replace(/px/g, ''))
    ]
    attr = @reference.getAttribute('viewBox')
    return [[1,0,0], [0,1,0], [0,0,1]] unless attr?
    viewBox = attr.replace(',', ' ').replace('  ', ' ').split(' ').map (e)->
      parseFloat(e)
    scale = [size[0] / viewBox[2], size[1] / viewBox[3] ]
    MatrixUtils.mult(
      [
        [scale[0], 0, 0]
        [0, scale[1], 0]
        [0, 0, 1]
      ],
      [
        [1, 0, -viewBox[0]],
        [0, 1, -viewBox[1]],
        [0, 0, 1]
      ],
    )
  offset: (element = null)->
    element ||= @reference
    return [element.offsetLeft, element.offsetTop] if element.offsetLeft?
    pos = @reference.getBoundingClientRect()
    offset = [pos.left, pos.top]
    parent = @parent(element)
    if parent?
      ppos = parent.getBoundingClientRect()
      offset[0] -= ppos.left
      offset[1] -= ppos.top
    offset
  css: (property, element = null)->
    element ||= @reference
    return Referentiel.jquery(element).css(property) if Referentiel.jquery
    window.getComputedStyle(element).getPropertyValue(property)
cache = (klass, functionName)->
  compute = klass[functionName]
  console.log klass
  klass.prototype[functionName] = ->
    console.log functionName, arguments...
cache Referentiel, 'matrix'
cache Referentiel, 'matrix_inv'

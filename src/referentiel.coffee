module.exports = class Referentiel
  constructor: (@reference)->
  global_to_local: (point)->
    @_multiply_point(@matrix_inv(), point)
  local_to_global: (point)->
    @_multiply_point(@matrix(), point)

  _multiply_point: (matrix, point)->
    v = [point[0], point[1], 1]
    res = @_multiply_vector(matrix, v)
    [ @_export(res[0]), @_export(res[1]) ]
  _export: (value)->
    res = @_round(value)
    return 0 if res == -0
    res
  _round: (value)->
    precision = 1000000.0
    Math.round(precision*value)/precision
  clear_cache: ->
    delete @_matrix_inv
    delete @_matrix
    delete @_matrix_transformation
    delete @_matrix_transform_origin
    delete @_matrix_svg

  matrix_inv: ->
    return @_matrix_inv if @_matrix_inv
    @_matrix_inv = @matrix_inv_compute()
    @_matrix_inv
  matrix_inv_compute: ->
    @_inv(@matrix())
  matrix: ->
    return @_matrix if @_matrix
    @_matrix = @matrix_compute()
    @_matrix
  matrix_compute: ->
    matrix_locale = @matrix_locale()
    if @getPropertyValue('position') == 'fixed'
      return matrix_locale
    if @reference.parentElement?
      parent_referentiel = new Referentiel(@reference.parentElement)
      return @_multiply(parent_referentiel.matrix(), matrix_locale)
    matrix_locale

  matrix_locale: ->
    return @_matrix_locale if @_matrix_locale
    @_matrix_locale = @matrix_locale_compute()
    @_matrix_locale
  matrix_locale_compute: ->
    @_multiply(
      @matrix_offset(),
      @_multiply(
        @matrix_transformation_with_origin(),
        @matrix_border()
      ),
    )

  matrix_transformation_with_origin: ->
    return @_matrix_transformation_with_origin if @_matrix_transformation_with_origin
    @_matrix_transformation_with_origin = @matrix_transformation_with_origin_compute()
    @_matrix_transformation_with_origin
  matrix_transformation_with_origin_compute: ->
    @_multiply(
      @_multiply(
        @matrix_transform_origin(),
        @matrix_transformation()
      ),
      @_inv(@matrix_transform_origin())
    )

  matrix_transformation: ->
    return @_matrix_transformation if @_matrix_transformation
    @_matrix_transformation = @matrix_transformation_compute()
    @_matrix_transformation
  matrix_transformation_compute: ->
    transform = @getPropertyValue('transform')
    if res = transform.match(/^matrix\((.*)\)$/)
      floats = res[1].split(',').map((e)->
        parseFloat(e)
      )
      return [[floats[0], floats[2], floats[4]],[floats[1], floats[3], floats[5]], [0, 0, 1]]
    [[1,0,0], [0,1,0], [0,0,1]]

  matrix_transform_origin: ->
    return @_matrix_transform_origin if @_matrix_transform_origin
    @_matrix_transform_origin = @matrix_transform_origin_compute()
    @_matrix_transform_origin

  matrix_transform_origin_compute: ->
    transform_origin = @getPropertyValue('transform-origin').replace(/px/g, '').split(' ').map (v)->
      parseFloat(v)
    [[1,0, transform_origin[0]], [0, 1, transform_origin[1]],[0,0,1]]

  matrix_border: ->
    return @_matrix_border if @_matrix_border
    @_matrix_border = @matrix_border_compute()
    @_matrix_border
  matrix_border_compute: ->
    left = parseFloat(@getPropertyValue('border-left-width').replace(/px/g, '') || 0)
    top = parseFloat(@getPropertyValue('border-top-width').replace(/px/g, '') || 0)
    [[1,0,left],[0,1,top],[0,0,1]]

  matrix_offset: ->
    return @_matrix_offset if @_matrix_offset
    @_matrix_offset = @matrix_offset_compute()
    @_matrix_offset
  matrix_offset_compute: ->
    return @matrix_svg() if @reference instanceof SVGElement
    [left, top] = @offset()
    switch @getPropertyValue('position')
      when 'absolute'
        return [[1,0,left],[0,1,top],[0,0,1]]
       when 'fixed'
        left += window.pageXOffset
        top += window.pageYOffset
        return [[1,0,left],[0,1,top],[0,0,1]]
    if @reference.parentElement?
      parent = @reference.parentElement
      parent_position = @getPropertyValue('position',parent)
      if parent_position ==  'static'
        [parent_left, parent_top] = @offset(parent)
        left -= parent_left
        top -= parent_top
    [[1,0,left],[0,1,top],[0,0,1]]

  matrix_svg: ->
    return @_matrix_svg if @_matrix_svg
    @_matrix_svg = @matrix_svg_compute()
    @_matrix_svg
  matrix_svg_compute: ->
    return [[1,0,0], [0,1,0], [0,0,1]] unless @reference instanceof SVGElement
    mat = @reference.getScreenCTM()
    return [[1,0,0], [0,1,0], [0,0,1]] unless mat
    [[mat.a, mat.b, mat.e], [mat.c, mat.d, mat.f], [0,0,1]]

  offset: (element = null)->
    element ||= @reference
    return [element.offsetLeft, element.offsetTop] if element.offsetLeft?
    domRect = element.getBoundingClientRect()
    [domRect.x, domRect.y]
  getPropertyValue: (property, element = null)->
    return Referentiel.jquery(element || @reference).css(property) if Referentiel.jquery
    window.getComputedStyle(element || @reference).getPropertyValue(property)
  _multiply_vector: (m, v)->
    res = []
    for i in [0...3]
      res[i] = 0.0
      for k in [0...3]
        res[i] += m[i][k]*v[k]
    res
  _multiply: (a, b)->
    res = []
    for i in [0...3]
      res[i] = []
      for j in [0...3]
        res[i][j] = 0.0
        for k in [0...3]
          res[i][j] += a[i][k]*b[k][j]
    res
  _det: (m)->
    return (
      m[0][0] * (m[1][1] * m[2][2] - m[2][1] * m[1][2]) -
      m[0][1] * (m[1][0] * m[2][2] - m[1][2] * m[2][0]) +
      m[0][2] * (m[1][0] * m[2][1] - m[1][1] * m[2][0])
    )
  _inv: (m)->
    invdet = 1.0/@_det(m)
    return [
      [
        (m[1][1] * m[2][2] - m[2][1] * m[1][2]) * invdet,
        (m[0][2] * m[2][1] - m[0][1] * m[2][2]) * invdet,
        (m[0][1] * m[1][2] - m[0][2] * m[1][1]) * invdet,
      ],
      [
        (m[1][2] * m[2][0] - m[1][0] * m[2][2]) * invdet,
        (m[0][0] * m[2][2] - m[0][2] * m[2][0]) * invdet,
        (m[1][0] * m[0][2] - m[0][0] * m[1][2]) * invdet,
      ],
      [
        (m[1][0] * m[2][1] - m[2][0] * m[1][1]) * invdet,
        (m[2][0] * m[0][1] - m[0][0] * m[2][1]) * invdet,
        (m[0][0] * m[1][1] - m[1][0] * m[0][1]) * invdet,
      ]
    ]

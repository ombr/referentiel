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
    precision = 10000000.0
    Math.round(precision*value)/precision
  clear_cache: ->
    delete @_matrix_inv
    delete @_matrix
    delete @_matrix_transformation
    delete @_matrix_transform_origin
    delete @_style

  matrix_inv: ->
    return @_matrix_inv if @_matrix_inv
    @_matrix_inv = @matrix_inv_compute()
    @_matrix_inv
  matrix_inv_compute: ->
    @_inv(@matrix())
  matrix: ->
    return @_matrix if @_matrix
    @_matrix = @matrix_compute()
    console.log 'matrix:', @reference, @_matrix
    @_matrix
  matrix_compute: ->
    # console.log 'Compute position:', @style().getPropertyValue('position'), @reference
    matrix_locale = new Referentiel(@reference).matrix_locale()
    if @style().getPropertyValue('position') == 'fixed'
      return matrix_locale
    if @reference.parentElement?
      parent_referentiel = new Referentiel(@reference.parentElement)
      return @_multiply(parent_referentiel.matrix(), matrix_locale)
    # parent = @offset_parent()
    # console.log 'parent', parent
    # if parent != null
    #   parent_referentiel = new Referentiel(parent)
    #   return @_multiply(matrix_locale, parent_referentiel.matrix())
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
    transform = @style().getPropertyValue('transform')
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
    transform_origin = @style().getPropertyValue('transform-origin').replace(/px/g, '').split(' ').map (v)->
      parseFloat(v)
    [[1,0, transform_origin[0]], [0, 1, transform_origin[1]],[0,0,1]]

  matrix_border: ->
    return @_matrix_border if @_matrix_border
    @_matrix_border = @matrix_border_compute()
    @_matrix_border
  matrix_border_compute: ->
    left = parseFloat(@style().getPropertyValue('border-left').split(' ')[0].replace(/px/g, ''))
    top = parseFloat(@style().getPropertyValue('border-top').split(' ')[0].replace(/px/g, ''))
    [[1,0,left],[0,1,top],[0,0,1]]

  # matrix_margin: ->
  #   return @_matrix_margin if @_matrix_margin
  #   @_matrix_margin = @matrix_margin_compute()
  #   @_matrix_margin
  # matrix_margin_compute: ->
  #   left = parseFloat(@style().getPropertyValue('margin-left').split(' ')[0].replace(/px/g, ''))
  #   top = parseFloat(@style().getPropertyValue('margin-top').split(' ')[0].replace(/px/g, ''))
  #   [[1,0,left],[0,1,top],[0,0,1]]
  #   [[1,0,0],[0,1,0],[0,0,1]]


  matrix_position_offset: ->
    return @_matrix_position_offset if @_matrix_position_offset
    @_matrix_position_offset = @matrix_position_offset_compute()
    @_matrix_position_offset
  matrix_position_offset_compute: ->
    left = 0
    top = 0
    # console.log 'Matrix computed ?', left, top
    [[1,0,-left],[0,1,-top],[0,0,1]]
  matrix_offset: ->
    return @_matrix_offset if @_matrix_offset
    @_matrix_offset = @matrix_offset_compute()
    @_matrix_offset
  matrix_offset_compute: ->
    left = @reference.offsetLeft
    top = @reference.offsetTop
    # console.log 'ref'
    # console.log @reference
    # console.log 'offset', left, top
    # console.log 'position', @style().getPropertyValue('left'), @style().getPropertyValue('top')
    # if @reference.parentElement?
    #   console.log 'parent', @reference.parentElement.offsetLeft, @reference.parentElement.offsetTop
    switch @style().getPropertyValue('position')
      # when 'absolute'
      #   left += @reference.parentElement.offsetLeft
      #   top += @reference.parentElement.offsetLeft
       when 'fixed'
        left = @reference.offsetLeft + window.scrollX
        top = @reference.offsetTop + window.scrollY
        return [[1,0,left],[0,1,top],[0,0,1]]
      #   console.log 'absolute', @reference.offsetLeft, @style().getPropertyValue('left'), @reference.parentElement.offsetLeft, @reference

    # if @reference.parentElement?
    #   left -= @reference.parentElement.offsetLeft
    #   top -= @reference.parentElement.offsetTop
    # console.log 'offsets', left, top, @reference
    [[1,0,left],[0,1,top],[0,0,1]]

  style: ->
    return @_style if @_style
    @_style = @style_compute()
    @_style
  style_compute: ->
    window.getComputedStyle(@reference, null)

  offset_parent: ()->
    i = 0
    e = @reference.parentElement
    loop
      return unless e?
      position = window.getComputedStyle(e, null).getPropertyValue('position')
      # console.log 'offset_parent', i, position, e
      return e if position != 'static'
      e = e.parentElement
      return null if i > 10
      i += 1

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

math = require('mathjs')
module.exports = class Referentiel
  constructor: (@reference)->
  global_to_local: (point)->
    @_multiply_point(@matrix_inv(), point)
  local_to_global: (point)->
    @_multiply_point(@matrix(), point)

  _multiply_point: (matrix, point)->
    v = [point[0], point[1], 1]
    res = @_multiply(matrix, v)
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
    @_matrix
  matrix_inv_compute: ->
    @_inv(@matrix())

  matrix: ->
    return @_matrix if @_matrix
    @_matrix = @matrix_compute()
    @_matrix
  matrix_compute: ->
    matrix = [[1,0,0],[0,1,0],[0,0,1]]
    e = @reference
    while(next = e.parentElement)
      m = new Referentiel(e).matrix_locale()
      matrix = @_multiply(matrix, m)
      e = next
    matrix

  matrix_locale: ->
    return @_matrix_locale if @_matrix_locale
    @_matrix_locale = @matrix_locale_compute()
    @_matrix_locale
  matrix_locale_compute: ->
    return @matrix_transformation()
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
    [[1,0,0], [0,1,0], [0,0,1]]

  style: ->
    return @_style if @_style
    @_style = @style_compute()
    @_style

  style_compute: ->
    window.getComputedStyle(@reference, null)

  _multiply: (args...)->
    math.multiply(args...)
  _inv: (args...)->
    math.inv(args...)

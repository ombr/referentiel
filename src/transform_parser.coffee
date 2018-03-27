MatrixUtils = require('./matrix_utils.coffee')
module.exports = TransformParser = {
  parse: (input)->
    return 'none' if input == 'none' || input == ''
    @to_css(
      @export_matrix(
        @parse_matrix(input)
      )
    )
  export_matrix: (m)->
    res = []
    for i in [0...3]
      res[i] = []
      for j in [0...3]
        res[i][j] = @export_value(m[i][j])
  export_value: (value)->
    precison = 100000
    Math.round(value*precison)/precison
  parse_matrix: (input)->
    matrix = [[1,0,0], [0,1,0], [0,0,1]]
    inputs = input.split(')')
    for i in inputs
      matrix = MatrixUtils.mult(
        matrix,
        @parseOperation("#{i})")
      )
    matrix
  parseOperation: (input)->
    if match = input.match(/^[ ]*(rotate|translate|translateX|translateY|scale|scaleX|scaleY)\((.*)\)$/)
      return @[match[1]](match[2])
    [[1,0,0], [0,1,0], [0,0,1]]
  scale: (input)->
    scale = input.split(',')
    scale[1] = scale[0] if scale.length == 1
    scale = [
      parseFloat(scale[0])
      parseFloat(scale[1])
    ]
    [
      [scale[0],0,0]
      [0,scale[1],0]
      [0,0,1]
    ]
  scaleX: (input)->
    @scale("#{input},1")
  scaleY: (input)->
    @scale("1, #{input}")
  translateX: (input)->
    @translate(input)
  translateY: (input)->
    @translate("0px, #{input}")
  translate: (input)->
    left = 0
    right = 0
    if match = input.match(/^(.*)px$/)
      left = parseFloat(match[1])
    if match = input.match(/^(.*)px, (.*)px$/)
      left = parseFloat(match[1])
      right = parseFloat(match[2])
    [
      [1,0,left]
      [0,1,right]
      [0,0,1]
    ]
  rotate: (input)->
    angle = 0
    if match = input.match(/^(.*)deg$/)
      angle = parseFloat(match[1]) * Math.PI / 180
    if match = input.match(/^(.*)turn$/)
      angle = parseFloat(match[1]) * Math.PI * 2
    [
      [Math.cos(angle),-Math.sin(angle), 0],
      [Math.sin(angle),Math.cos(angle), 0],
      [0,0,1]
    ]
  to_css: (m)->
    "matrix(#{[m[0][0], m[1][0], m[0][1], m[1][1], m[0][2], m[1][2]].join(', ')})"
}

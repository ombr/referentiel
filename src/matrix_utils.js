const MatrixUtils = {
  identity: function() {
    return [[1, 0, 0], [0, 1, 0], [0, 0, 1]];
  },
  det: function(m) {
    return m[0][0] * (m[1][1] * m[2][2] - m[2][1] * m[1][2]) - m[0][1] * (m[1][0] * m[2][2] - m[1][2] * m[2][0]) + m[0][2] * (m[1][0] * m[2][1] - m[1][1] * m[2][0]);
  },
  inv: function(m) {
    var invdet;
    invdet = 1.0 / MatrixUtils.det(m);
    return [[(m[1][1] * m[2][2] - m[2][1] * m[1][2]) * invdet, (m[0][2] * m[2][1] - m[0][1] * m[2][2]) * invdet, (m[0][1] * m[1][2] - m[0][2] * m[1][1]) * invdet], [(m[1][2] * m[2][0] - m[1][0] * m[2][2]) * invdet, (m[0][0] * m[2][2] - m[0][2] * m[2][0]) * invdet, (m[1][0] * m[0][2] - m[0][0] * m[1][2]) * invdet], [(m[1][0] * m[2][1] - m[2][0] * m[1][1]) * invdet, (m[2][0] * m[0][1] - m[0][0] * m[2][1]) * invdet, (m[0][0] * m[1][1] - m[1][0] * m[0][1]) * invdet]];
  },
  mult: function() {
    var a, b, i, j, k, l, n, o, others, res;
    [a, b, ...others] = arguments;
    res = [];
    for (i = l = 0; l < 3; i = ++l) {
      res[i] = [];
      for (j = n = 0; n < 3; j = ++n) {
        res[i][j] = 0.0;
        for (k = o = 0; o < 3; k = ++o) {
          res[i][j] += a[i][k] * b[k][j];
        }
      }
    }
    if (others.length > 0) {
      return MatrixUtils.mult(res, ...others);
    } else {
      return res;
    }
  },
  multVector: function(m, v) {
    var i, k, l, n, res;
    res = [];
    for (i = l = 0; l < 3; i = ++l) {
      res[i] = 0.0;
      for (k = n = 0; n < 3; k = ++n) {
        res[i] += m[i][k] * v[k];
      }
    }
    return res;
  }
};

export default MatrixUtils;

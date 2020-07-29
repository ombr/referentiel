import MatrixUtils from './matrix_utils.js';

class Referentiel {
  constructor(reference, options = {}) {
    this.reference = reference;
    this.options = options;
  }

  global_to_local(point) {
    return this._multiplyPoint(this.matrixInv(), point);
  }

  local_to_global(point) {
    return this._multiplyPoint(this.matrix(), point);
  }

  _multiplyPoint(matrix, point) {
    var res, v;
    v = [point[0], point[1], 1];
    res = MatrixUtils.multVector(matrix, v);
    return [this._export(res[0]), this._export(res[1])];
  }

  _export(value) {
    var res;
    res = this._round(value);
    if (res === -0) {
      return 0;
    }
    return res;
  }

  _round(value) {
    var precision;
    precision = 1000000.0;
    return Math.round(precision * value) / precision;
  }

  matrixInv() {
    return MatrixUtils.inv(this.matrix());
  }

  matrix() {
    var matrixLocale, parent;
    matrixLocale = this.matrixLocale();
    if (this.css('position') === 'fixed') {
      return matrixLocale;
    }
    parent = this.parent();
    if (parent) {
      return MatrixUtils.mult((new Referentiel(parent, {
        offsetParent: this.reference.offsetParent
      })).matrix(), matrixLocale);
    }
    return matrixLocale;
  }

  matrixLocale() {
    return MatrixUtils.mult(this.matrixSVGViewbox(), this.matrixOffset(), this.matrixTransformOrigin(), this.matrixTransform(), MatrixUtils.inv(this.matrixTransformOrigin()), this.matrixBorder());
  }

  matrixTransform() {
    var floats, res, transform;
    transform = this.reference.getAttribute('transform') || 'none';
    if (!transform.match(/^matrix\((.*)\)$/)) {
      transform = this.reference.style.transform;
    }
    if (!transform.match(/^matrix\((.*)\)$/)) {
      transform = this.css('transform');
    }
    if (res = transform.match(/^matrix\((.*)\)$/)) {
      floats = res[1].replace(',', ' ').replace('  ', ' ').split(' ').map(function(e) {
        return parseFloat(e);
      });
      return [[floats[0], floats[2], floats[4]], [floats[1], floats[3], floats[5]], [0, 0, 1]];
    }
    return MatrixUtils.identity();
  }

  matrixTransformOrigin() {
    var transform_origin;
    transform_origin = this.css('transform-origin').replace(/px/g, '').split(' ').map(function(v) {
      return parseFloat(v);
    });
    return [[1, 0, transform_origin[0]], [0, 1, transform_origin[1]], [0, 0, 1]];
  }

  matrixBorder() {
    var left, top;
    left = parseFloat(this.css('border-left-width').replace(/px/g, '') || 0);
    top = parseFloat(this.css('border-top-width').replace(/px/g, '') || 0);
    return [[1, 0, left], [0, 1, top], [0, 0, 1]];
  }

  parent(element) {
    element || (element = this.reference);
    if ((element.parentNode != null) && element.parentNode !== document.documentElement) {
      return element.parentNode;
    } else {
      return null;
    }
  }

  matrixOffset() {
    var left, top;
    [left, top] = this.offset();
    switch (this.css('position')) {
      case 'absolute':
        return [[1, 0, left], [0, 1, top], [0, 0, 1]];
      case 'fixed':
        left += window.pageXOffset;
        top += window.pageYOffset;
        return [[1, 0, left], [0, 1, top], [0, 0, 1]];
    }
    if (this.options.offsetParent != null) {
      if (this.options.offsetParent !== this.reference) {
        [left, top] = [0, 0];
      }
    }
    return [[1, 0, left], [0, 1, top], [0, 0, 1]];
  }

  matrixSVGViewbox() {
    var attr, scale, size, viewBox;
    if (!(this.reference instanceof SVGElement)) {
      return MatrixUtils.identity();
    }
    size = [parseFloat(this.css('width').replace(/px/g, '')), parseFloat(this.css('height').replace(/px/g, ''))];
    attr = this.reference.getAttribute('viewBox');
    if (attr == null) {
      return MatrixUtils.identity();
    }
    viewBox = attr.replace(',', ' ').replace('  ', ' ').split(' ').map(function(e) {
      return parseFloat(e);
    });
    scale = [size[0] / viewBox[2], size[1] / viewBox[3]];
    return MatrixUtils.mult([[scale[0], 0, 0], [0, scale[1], 0], [0, 0, 1]], [[1, 0, -viewBox[0]], [0, 1, -viewBox[1]], [0, 0, 1]]);
  }

  offset(element = null) {
    var offset, parent, pos, ppos;
    element || (element = this.reference);
    if (element.offsetLeft != null) {
      return [element.offsetLeft, element.offsetTop];
    }
    pos = this.reference.getBoundingClientRect();
    offset = [pos.left, pos.top];
    parent = this.parent(element);
    if (parent != null) {
      ppos = parent.getBoundingClientRect();
      offset[0] -= ppos.left;
      offset[1] -= ppos.top;
    }
    return offset;
  }

  css(property, element = null) {
    element || (element = this.reference);
    if (Referentiel.jquery) {
      return Referentiel.jquery(element).css(property);
    }
    return window.getComputedStyle(element).getPropertyValue(property);
  }

};

function cache(klass, functionName) {
  var func;
  func = klass.prototype[functionName];
  return klass.prototype[functionName] = function() {
    this._cache || (this._cache = {});
    if (!this._cache[functionName]) {
      this._cache[functionName] = func.apply(this, arguments);
    }
    return this._cache[functionName];
  };
};

cache(Referentiel, 'matrix');
cache(Referentiel, 'matrixInv');

export { Referentiel, MatrixUtils };

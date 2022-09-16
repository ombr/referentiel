var __decorate = (this && this.__decorate) || function (decorators, target, key, desc) {
    var c = arguments.length, r = c < 3 ? target : desc === null ? desc = Object.getOwnPropertyDescriptor(target, key) : desc, d;
    if (typeof Reflect === "object" && typeof Reflect.decorate === "function") r = Reflect.decorate(decorators, target, key, desc);
    else for (var i = decorators.length - 1; i >= 0; i--) if (d = decorators[i]) r = (c < 3 ? d(r) : c > 3 ? d(target, key, r) : d(target, key)) || r;
    return c > 3 && r && Object.defineProperty(target, key, r), r;
};
var __metadata = (this && this.__metadata) || function (k, v) {
    if (typeof Reflect === "object" && typeof Reflect.metadata === "function") return Reflect.metadata(k, v);
};
var __spreadArray = (this && this.__spreadArray) || function (to, from, pack) {
    if (pack || arguments.length === 2) for (var i = 0, l = from.length, ar; i < l; i++) {
        if (ar || !(i in from)) {
            if (!ar) ar = Array.prototype.slice.call(from, 0, i);
            ar[i] = from[i];
        }
    }
    return to.concat(ar || Array.prototype.slice.call(from));
};
import { multiply, matrix, inv, identity, } from "mathjs";
function cache(_target, propertyKey, descriptor) {
    var cacheKey = "_".concat(propertyKey);
    if (!descriptor)
        return;
    var originalMethod = descriptor.value;
    // eslint-disable-next-line @typescript-eslint/no-explicit-any
    descriptor.value = function () {
        // eslint-disable-next-line no-prototype-builtins
        if (this.hasOwnProperty(cacheKey)) {
            return this[cacheKey];
        }
        this[cacheKey] = originalMethod.apply(this, []);
        return this[cacheKey];
    };
}
var Referentiel = /** @class */ (function () {
    function Referentiel(reference, offsetParent) {
        if (offsetParent === void 0) { offsetParent = null; }
        this.reference = reference;
        this.offsetParent = offsetParent;
    }
    Referentiel.convertPointFromPageToNode = function (node, point) {
        var referenciel = new Referentiel(node);
        return referenciel.convertPointFromPageToNode(point);
    };
    Referentiel.prototype.convertPointFromPageToNode = function (point) {
        return this.globalToLocal(point);
    };
    Referentiel.prototype.globalToLocal = function (point) {
        return this._multiplyPoint(this.matrixInv(), point);
    };
    Referentiel.prototype.localToGlobal = function (point) {
        return this._multiplyPoint(this.matrix(), point);
    };
    Referentiel.prototype._multiplyPoint = function (m, point) {
        var _a = multiply(m, matrix([point[0], point[1], 1])).toArray(), a = _a[0], b = _a[1];
        if (a === undefined || b === undefined)
            throw new Error("Oh no !");
        if (Array.isArray(a) || Array.isArray(b))
            throw new Error("We are not expecting an array");
        return [this["export"](a), this["export"](b)];
    };
    Referentiel.prototype["export"] = function (v) {
        return parseFloat(v.toString());
    };
    Referentiel.prototype._round = function (value) {
        var precision = 1000000.0;
        return Math.round(precision * value) / precision;
    };
    Referentiel.prototype.matrixInv = function () {
        return inv(this.matrix());
    };
    Referentiel.prototype.matrix = function () {
        var matrixLocale = this.matrixLocale();
        if (this.css("position") === "fixed") {
            return matrixLocale;
        }
        var parent = this.parent(this.reference);
        if (parent) {
            return multiply(new Referentiel(parent, Referentiel.offsetParent(this.reference)).matrix(), matrixLocale);
        }
        return matrixLocale;
    };
    Referentiel.offsetParent = function (node) {
        if (node instanceof HTMLElement) {
            return node.offsetParent;
        }
        return null;
    };
    Referentiel.prototype.matrixLocale = function () {
        return Referentiel.mult(this.matrixSVGViewbox(), this.matrixOffset(), this.matrixTransformOrigin(), this.matrixTransform(), inv(this.matrixTransformOrigin()), this.matrixBorder());
    };
    Referentiel.prototype.matrixTransform = function () {
        if (!(this.reference instanceof HTMLElement)) {
            return Referentiel.identity();
        }
        var transform = this.reference.getAttribute("transform") || "none";
        if (!transform.match(/^matrix\((.*)\)$/)) {
            transform = this.reference.style.transform;
        }
        if (!transform.match(/^matrix\((.*)\)$/)) {
            transform = this.css("transform");
        }
        var res = transform.match(/^matrix\((.*)\)$/);
        if (!res || !res[1]) {
            return Referentiel.identity();
        }
        var floatsStr = res[1].replace(",", " ").replace("  ", " ").split(" ");
        if (floatsStr.length !== 6)
            throw new Error("Transform matrix error");
        var floats = floatsStr.map(function (e) {
            return parseFloat(e);
        }); //! TODO We should do better here.
        return matrix([
            [floats[0], floats[2], floats[4]],
            [floats[1], floats[3], floats[5]],
            [0, 0, 1],
        ]);
    };
    Referentiel.prototype.matrixTransformOrigin = function () {
        var transformOriginAttr = this.css("transform-origin")
            .replace(/px/g, "")
            .split(" ")
            .map(function (v) {
            return parseFloat(v) || 0;
        });
        if (transformOriginAttr.length !== 2)
            throw new Error("Transform origin parsing error"); //! TODO We should do better here.
        var transformOrigin = transformOriginAttr;
        return matrix([
            [1, 0, transformOrigin[0]],
            [0, 1, transformOrigin[1]],
            [0, 0, 1],
        ]);
    };
    Referentiel.prototype.matrixBorder = function () {
        var left = parseFloat(this.css("border-left-width").replace(/px/g, "")) || 0;
        var top = parseFloat(this.css("border-top-width").replace(/px/g, "")) || 0;
        return matrix([
            [1, 0, left],
            [0, 1, top],
            [0, 0, 1],
        ]);
    };
    Referentiel.prototype.parent = function (element) {
        if (element.parentNode != null &&
            element.parentNode !== document.documentElement) {
            return element.parentNode;
        }
        else {
            return null;
        }
    };
    Referentiel.prototype.matrixOffset = function () {
        var _a;
        var _b = this.offset(this.reference), left = _b[0], top = _b[1];
        switch (this.css("position")) {
            case "absolute":
                return matrix([
                    [1, 0, left],
                    [0, 1, top],
                    [0, 0, 1],
                ]);
            case "fixed":
                left += window.pageXOffset;
                top += window.pageYOffset;
                return matrix([
                    [1, 0, left],
                    [0, 1, top],
                    [0, 0, 1],
                ]);
        }
        if (this.offsetParent != null) {
            if (this.offsetParent !== this.reference) {
                _a = [0, 0], left = _a[0], top = _a[1];
            }
        }
        return matrix([
            [1, 0, left],
            [0, 1, top],
            [0, 0, 1],
        ]);
    };
    Referentiel.prototype.matrixSVGViewbox = function () {
        if (!(this.reference instanceof window.SVGElement)) {
            return Referentiel.identity();
        }
        var size = [
            parseFloat(this.css("width").replace(/px/g, "")),
            parseFloat(this.css("height").replace(/px/g, "")),
        ];
        var attr = this.reference.getAttribute("viewBox");
        if (attr == null) {
            return Referentiel.identity();
        }
        var viewBoxAttr = attr
            .replace(",", " ")
            .replace("  ", " ")
            .split(" ")
            .map(function (e) {
            return parseFloat(e);
        });
        if (viewBoxAttr.length !== 4)
            throw new Error("Viewbox parsing error");
        var viewBox = viewBoxAttr; //! TODO find a better way ?
        var scale = [
            size[0] / viewBox[2],
            size[1] / viewBox[3],
        ];
        return Referentiel.mult(matrix([
            [scale[0], 0, 0],
            [0, scale[1], 0],
            [0, 0, 1],
        ]), matrix([
            [1, 0, -viewBox[0]],
            [0, 1, -viewBox[1]],
            [0, 0, 1],
        ]));
    };
    Referentiel.prototype.offset = function (element) {
        if (!(element instanceof HTMLElement || element instanceof SVGElement)) {
            return [0, 0];
        }
        if (!(this.reference instanceof HTMLElement ||
            this.reference instanceof SVGElement)) {
            return [0, 0];
        }
        if (element instanceof HTMLElement) {
            return [element.offsetLeft, element.offsetTop];
        }
        var pos = this.reference.getBoundingClientRect();
        var offset = [pos.left, pos.top];
        var parent = this.parent(element);
        if (parent instanceof HTMLElement || parent instanceof SVGElement) {
            var ppos = parent.getBoundingClientRect();
            offset[0] -= ppos.left;
            offset[1] -= ppos.top;
        }
        return offset;
    };
    Referentiel.prototype.css = function (property) {
        if (Referentiel.jquery) {
            return Referentiel.jquery(this.reference).css(property);
        }
        console.log("ICIC", this.reference, property);
        if (this.reference instanceof Element ||
            this.reference instanceof SVGElement) {
            return window.getComputedStyle(this.reference).getPropertyValue(property);
        }
        return "";
    };
    Referentiel.mult = function () {
        var args = [];
        for (var _i = 0; _i < arguments.length; _i++) {
            args[_i] = arguments[_i];
        }
        var a = args[0], b = args[1], rest = args.slice(2);
        if (!a)
            throw new Error("Matrix is null");
        if (!b)
            return a;
        return Referentiel.mult.apply(Referentiel, __spreadArray([multiply(a, b)], rest, false));
    };
    Referentiel.identity = function () {
        return identity(3);
    };
    __decorate([
        cache,
        __metadata("design:type", Function),
        __metadata("design:paramtypes", []),
        __metadata("design:returntype", Function)
    ], Referentiel.prototype, "matrixInv");
    __decorate([
        cache,
        __metadata("design:type", Function),
        __metadata("design:paramtypes", []),
        __metadata("design:returntype", Function)
    ], Referentiel.prototype, "matrix");
    return Referentiel;
}());
export { Referentiel };
//# sourceMappingURL=referentiel.js.map
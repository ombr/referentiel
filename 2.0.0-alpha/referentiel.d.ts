import { type Matrix, MathNumericType } from "mathjs";
declare class Referentiel {
    reference: Node;
    static jquery?: (element: Node) => {
        css: (a: string) => string;
    };
    offsetParent: Node | null;
    constructor(reference: Node, offsetParent?: Node | null);
    static convertPointFromPageToNode(node: Node, point: [number, number]): [number, number];
    convertPointFromPageToNode(point: [number, number]): [number, number];
    globalToLocal(point: [number, number]): [number, number];
    localToGlobal(point: [number, number]): [number, number];
    _multiplyPoint(m: Matrix, point: [number, number]): [number, number];
    export(v: MathNumericType): number;
    _round(value: number): number;
    matrixInv(): Matrix;
    matrix(): Matrix;
    static offsetParent(node: Node): Node | null;
    matrixLocale(): Matrix;
    matrixTransform(): Matrix;
    matrixTransformOrigin(): Matrix;
    matrixBorder(): Matrix;
    parent(element: Node): Node | null;
    matrixOffset(): Matrix;
    matrixSVGViewbox(): Matrix;
    offset(element: Node): [number, number];
    css(property: string): string;
    static mult(...args: Matrix[]): Matrix;
    static identity(): Matrix;
}
export { Referentiel };

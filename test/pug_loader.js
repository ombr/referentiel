let loadTemplate, parseAssert;
const $ = window.$;
// const Referentiel = window.Referentiel;
const it = window.it;
const describe = window.describe;
const expect = window.expect;

loadTemplate = function (templateName, callback) {
  return $.get({
    url: "/base/test/" + templateName + ".html",
    dataType: "text",
    success: callback,
  });
};

parseAssert = function (input) {
  return $.map(input.split(":"), function (i) {
    return [
      $.map(i.split(","), function (s) {
        return parseFloat(s);
      }),
    ];
  });
};

describe("Pug", function () {
  let addTest, j, len, ref, results, runTestFromTemplate, templateName;
  runTestFromTemplate = function (templateName, callback) {
    loadTemplate(templateName, function (template) {
      console.log("template Loaded", templateName, template);
      let $context;
      $context = $(
        '<div style="position: fixed; top: 0; left: 0">' + template + "</div>"
      );
      $("body").append($context);
      $(".referentiel", $context).each(function () {
        let referentiel;
        referentiel = new Referentiel.Referentiel(this);
        return $("[data-assert]", this).each(function (assert) {
          let result, round;
          const parsed = parseAssert($(this).data("assert"));
          const global = parsed[0];
          const local = parsed[1];
          round = function (value) {
            const v = Math.round(value * 1000) / 1000;
            if (v === -0) {
              return 0;
            }
            return v;
          };
          result = referentiel.convertPointFromPageToNode(global);
          result = [round(result[0]), round(result[1])];
          console.log(
            "assert",
            global,
            local,
            result,
            referentiel.localToGlobal(local)
          );
          return expect(result).toEqual(local);
        });
      });
      callback();
    });
  };
  addTest = function (templateName) {
    return it(templateName, function (done) {
      runTestFromTemplate(templateName, done);
    });
  };
  ref = [
    "basic",
    "borders",
    "margins",
    "margins2",
    "padding",
    "rotation-transform-origin",
    "rotation-transform-origin",
    "position-offset",
    "position-in-flow",
    "rotation",
    "rotation-scale",
    "svg-basic",
    "svg-viewport",
    "svg-margin",
    "svg-border",
    "svg-no-viewbox",
    "svg-composition",
    "position-basique",
    "position-scoped",
    "fixed",
    "fixed_offset",
    "absolute",
    "absolute_tricky",
    "absolute_stacked",
    "absolute_transformations",
  ];
  results = [];
  for (j = 0, len = ref.length; j < len; j++) {
    templateName = ref[j];
    // 'svg-group',
    results.push(addTest(templateName));
  }
  return results;
});

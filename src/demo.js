const $ = window.$;
const Referentiel = window.Referentiel;
$(function () {
  let addMarker, parseAssert;
  parseAssert = function (input) {
    return $.map(input.split(":"), function (i) {
      return [
        $.map(i.split(","), function (s) {
          return parseFloat(s);
        }),
      ];
    });
  };
  addMarker = function (point) {
    let $marker;
    $marker = $('<div class="marker"></div>');
    $marker.css("top", point[1] - 5);
    $marker.css("left", point[0] - 5);
    $marker.attr("data-x", point[0]);
    $marker.attr("data-y", point[1]);
    return $("body").append($marker);
  };
  $(".referentiel").each(function () {
    const ref = new Referentiel.Referentiel(this);
    return $("[data-assert]", this).each(function (assert) {
      let $assert, result;
      const parsed = parseAssert($(this).data("assert"));
      const global = parsed[0];
      const local = parsed[1];
      result = ref.globalToLocal(global);
      console.log(this, global, result, local);
      addMarker(global);
      $assert = $(this);
      $assert.css("left", result[0] - 3);
      $assert.css("top", result[1] - 3);
      $assert.attr("cx", result[0]);
      $assert.attr("cy", result[1]);
      $assert.data("x", result[0]);
      return $assert.data("y", result[1]);
    });
  });
  return $("body").on("click", function (e) {
    return $(".referentiel").each(function () {
      let $pointer, input, p, ref;
      ref = new Referentiel.Referentiel(this);
      input = [e.pageX, e.pageY];
      p = ref.globalToLocal(input);
      if ($(".pointer", this).length === 0) {
        $pointer = $('<div class="pointer"></div>');
        $(this).append($pointer);
      }
      $pointer = $(".pointer", this);
      console.log("======");
      console.log(
        input,
        "->",
        p,
        new Referentiel.Referentiel(this).matrix(),
        this
      );
      $pointer.css("left", p[0] - 3);
      $pointer.css("top", p[1] - 3);
      $pointer.attr("cx", p[0]);
      return $pointer.attr("cy", p[1]);
    });
  });
});

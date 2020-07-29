var load_template, parse_assert;

load_template = function(template_name, callback) {
  return $.get({
    url: '/base/test/' + template_name + '.html',
    dataType: 'text',
    success: callback
  });
};

parse_assert = function(input) {
  return $.map(input.split(':'), function(i) {
    return [
      $.map(i.split(','),
      function(s) {
        return parseFloat(s);
      })
    ];
  });
};

describe("Pug", function() {
  var add_test, j, len, ref, results, run_test_from_template, template_name;
  run_test_from_template = function(template_name, callback) {
    return load_template(template_name, function(template) {
      var $context;
      $context = $('<div style="position: fixed; top: 0; left: 0">' + template + '</div>');
      $('body').append($context);
      $('.referentiel', $context).each(function() {
        var referentiel;
        referentiel = new Referentiel.Referentiel(this);
        return $('[data-assert]', this).each(function(assert) {
          var result, round;
          var parsed = parse_assert($(this).data('assert'));
          var global = parsed[0];
          var local = parsed[1];
          round = function(value) {
            return Math.round(value * 1000) / 1000;
          };
          result = referentiel.global_to_local(global);
          result = [round(result[0]), round(result[1])];
          // console.log('assert', global, local, result, referentiel.local_to_global(local));
          return expect(result).toEqual(local);
        });
      });
      return callback();
    });
  };
  add_test = function(template_name) {
    return it(template_name, function(done) {
      return run_test_from_template(template_name, done);
    });
  };
  ref = ['basic', 'borders', 'margins', 'margins2', 'padding', 'rotation-transform-origin', 'rotation-transform-origin', 'position-offset', 'position-in-flow',
    'rotation', 'rotation-scale', 'svg-basic', 'svg-viewport', 'svg-margin', 'svg-border', 'svg-no-viewbox', 'svg-composition',
    'position-basique', 'position-scoped', 'fixed', 'fixed_offset', 'absolute', 'absolute_tricky', 'absolute_stacked', 'absolute_transformations'];
  results = [];
  for (j = 0, len = ref.length; j < len; j++) {
    template_name = ref[j];
    // 'svg-group',
    results.push(add_test(template_name));
  }
  return results;
});

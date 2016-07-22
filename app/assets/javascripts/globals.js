function only_on_page(name, fn) {
  if ($('body').data('page') === name) {
    fn();
  }
}

function init_on_page(name, fn) {
  $(document).on('turbolinks:load', function () {
    only_on_page(name, function() {
      fn();
    });
  });
}

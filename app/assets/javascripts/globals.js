function on_page(name, fn) {
  if ($('body').data('page') === name) {
    fn();
  }
}

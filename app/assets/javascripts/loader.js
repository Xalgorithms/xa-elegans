$(document).on('turbolinks:load', function () {
  var $body = $('body');
  var page = $body.data('page');
  var action = $body.data('action');

  init_on_page($body.data('page'), $body.data('action'));
});

$(document).ready(function() {
  $('a[data-remote]').on('ajax:success', function (e, data, status, xhr) {
    $(this).closest('div.row').detach();
  });
});

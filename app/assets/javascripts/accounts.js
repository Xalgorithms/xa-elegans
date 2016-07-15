function init() {
  on_page('accounts', function() {
    $('.modal').on('hidden.bs.modal', function () {
      $(this).removeData();
    });
    $('#modal-invocation-edit').on('ajax:success', function (e, o) {
      console.log(o);
      $(this).modal('hide');
    });
    $('#modal-invocation-create').on('ajax:success', function (e, o) {
      console.log(o);
      $(this).modal('hide');
    });
  });
};

$(document).on('ready page:load', init);

function bind_delete_success(el) {
  el.on('ajax:success', function (e) {
    var self = this;
    $(this).closest('div.row').fadeOut(100, function () {
      $(self).detach();
    });
  });
}

function add_invocation(o) {
  var el = _.first($(o).appendTo('#container-account-rules'));
  bind_delete_success($(el));
}

function update_invocation(o, id) {
  $('#invocation-' + id).replaceWith(o);
  bind_delete_success($('#invocation-' + id));
}

function get_invocation_template(o, fn) {
  $.get(Routes.account_invocation_path(o.account_id, o.id), function (h) {
    fn(h, o.id);
  });
}

function modal_ajax_success(fn) {
  return function (e, o) {
    get_invocation_template(o, fn);
    $(this).modal('hide');
  };
}

function init() {
  on_page('accounts', function() {
    $('.modal').on('hidden.bs.modal', function () {
      $(this).removeData();
    });
    $('#modal-invocation-edit').on('ajax:success', modal_ajax_success(update_invocation));
    $('#modal-invocation-create').on('ajax:success', modal_ajax_success(add_invocation));
    bind_delete_success($('a[data-remote]'));
  });
};

$(document).on('ready page:load', init);

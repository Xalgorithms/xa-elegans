var form_vm = {
  transaction_id: ko.observable()
};

function associate(tr) {
  $('#modal-associate').modal('toggle');
  form_vm.transaction_id(tr.id);
}

function init() {
  console.log('transactions: init');

  var styles = {
      'open' : 'panel-success',
      'closed' : 'panel-info'
  };

  $('.new_transaction_associate_rule_event').on('ajax:success', function (e, o) {
    $('#modal-associate').modal('toggle');
    $.getJSON(o.url, function (o) {
      console.log(o);
      // $.getJSON(o.transformation.url, function (tx) {
      // });
    });    
  });

  vm.transaction_parts = ko.computed(function () {
    return _.chunk(vm.transactions(), 4);
  });

  vm.decorate_transactions = function (trs) {
    return _.map(trs, function (tr) {
      return _.extend(tr, {
	panel_style : _.get(styles, tr.status, 'panel-info'),
	status_label : _.get(labels, tr.status),
	trigger_associate : associate
      });
    });
  };

  ko.applyBindings(vm, document.getElementById('transactions'));
  ko.applyBindings(form_vm, document.getElementById('modal-associate'));
}

init_on_page('transactions', init);

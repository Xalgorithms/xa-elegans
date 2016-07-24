var form_vm = {
  transaction_id:  ko.observable(),
  rules:           ko.observableArray(),
  transformations: ko.observableArray()
};

var vm = {
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

  var documents = {
  };

  var rules = ko.observableArray();
  
  $('.new_transaction_associate_rule_event').on('ajax:success', function (e, o) {
    $('#modal-associate').modal('toggle');
    $.getJSON(o.url, function (o) {
      var tr = _.find(vm.transactions(), function (tr) {
	return tr.id == o.transaction.id;
      });
      if (tr) {
	tr.associations.push(o);
      }
    });    
  });

  _.each(transactions, function (tr) {
    _.each(tr.invoices, function (inv) {
      _.set(documents, inv.id, ko.observable());
      $.getJSON(inv.document.url, function (content) {
	_.get(documents, inv.id)(content);
      });
    });
  });

  $.getJSON(Routes.api_v1_rules_path(), function (o) {
    form_vm.rules(o);
  });

  $.getJSON(Routes.api_v1_transformations_path(), function (o) {
    form_vm.transformations(o);
  });

  vm.transactions = ko.computed(function () {
    return _.map(transactions, function (tr) {
      return _.extend(tr, {
	panel_style :     _.get(styles, tr.status, 'panel-info'),
	status_label      : _.get(labels, tr.status),
	trigger_associate : associate,
	invoices:         _.map(tr.invoices, function (invoice) {
	  return _.extend(invoice, {
	    content: _.get(documents, invoice.id)
	  });
	  }),
	associations:     ko.observableArray(tr.associations)
      });
    });
  });
  
  vm.transaction_view_models = ko.computed(function () {
    return _.chunk(vm.transactions(), 4);
  });

  ko.applyBindings(vm, document.getElementById('transactions'));
  ko.applyBindings(form_vm, document.getElementById('modal-associate'));
}

init_on_page('transactions', init);

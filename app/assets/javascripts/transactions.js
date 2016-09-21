(function () {
  var associate_vm = {
    transaction_id:  ko.observable(),
    rules:           ko.observableArray(),
    transformations: ko.observableArray()
  };

  var add_invoice_vm = {
    transaction_id: ko.observable()
  };

  var page_vm = {
  };

  function associate(tr) {
    $('#modal-associate').modal('toggle');
    associate_vm.transaction_id(tr.id);
  }

  function add_invoice(tr) {
    $('#modal-add-invoice').modal('toggle');
    add_invoice_vm.transaction_id(tr.id);
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
	var tr = _.find(page_vm.transactions(), function (tr) {
	  return tr.id == o.transaction.id;
	});
	if (tr) {
	  tr.associations.push(o);
	}
      });    
    });
    
    $('.new_transaction_add_invoice_event').on('ajax:success', function (e, o) {
      $('#modal-add-invoice').modal('toggle');
      $.getJSON(o.url, function (event) {
	$.getJSON(event.invoice.url, function (invoice) {
	  var tr = _.find(page_vm.transactions(), function (tr) {
	    return tr.id == event.transaction.id;
	  });
	  if (tr) {
	    tr.invoices.push(invoice);
	  }	  
	});
      });    
    });

    _.each(transactions, function (tr) {
      _.each(tr.invoices, function (inv) {
        var latest = _.last(inv.revisions);
	_.set(documents, inv.id, ko.observable());

        if (latest) {
	  $.getJSON(latest.document.url, function (content) {
	    _.get(documents, inv.id)(content);
	  });
        }
      });
    });

    $.getJSON(Routes.api_v1_rules_path(), function (o) {
      associate_vm.rules(o);
    });

    $.getJSON(Routes.api_v1_transformations_path(), function (o) {
      associate_vm.transformations(o);
    });

    page_vm.transactions = ko.observableArray(transactions);

    // TODO: clean this up
    page_vm.transaction_view_models = ko.computed(function () {
      var vms = _.map(page_vm.transactions(), function (tr) {
	var tr_vm = _.extend({}, tr, {
	  panel_style :     _.get(styles, tr.status, 'panel-info'),
	  status_label      : _.get(labels, tr.status),
	  trigger_associate : associate,
          trigger_add_invoice: add_invoice,
	  invoices:         ko.observableArray(_.map(tr.invoices, function (invoice) {
	    return _.extend({}, invoice, {
	      content: _.get(documents, invoice.id)
	    });
	  })),
	  trigger_close:    function (o) {
	    $.post(Routes.api_v1_events_path(), {
	      event_type: 'transaction_close',
	      transaction_close_event: { transaction_public_id: o.id }
	    }, function (resp) {
	      $.getJSON(resp.url, function (evt) {
		page_vm.transactions.remove(function (it) {
		  return it.id == evt.transaction.id;
		});
		$.getJSON(evt.transaction.url, function (tr) {
		  page_vm.transactions.push(tr);
		});
              });
	    });
	  },
          trigger_execute: function (o) {
            $.post(Routes.api_v1_events_path(), {
              event_type: 'transaction_execute',
              transaction_execute_event: { transaction_public_id: o.id }
            }, function (resp) {
              $.getJSON(resp.url, function (evt) {
		console.log(evt);
	      });
            });
          },
	  associations:     ko.observableArray(tr.associations)
	});

	// computeds
	tr_vm.format_url = ko.computed(function () {
	  return Routes.api_v1_transformation_path(tr.id);
	});
	
	tr_vm.closed = ko.computed(function () {
	  return 'closed' === tr.status;
	});
	
	tr_vm.have_invoices = ko.computed(function () {
	  return tr_vm.invoices().length > 0;
	});

	tr_vm.have_associations = ko.computed(function () {
	  return tr_vm.associations().length > 0;
	});
	
	return tr_vm;
      });

      return _.chunk(vms, 4);
    });

    page_vm.add = function () {
      $.post(Routes.api_v1_events_path(), {
	event_type: 'transaction_open',
	transaction_open_event: { user_id: user_id }
      }, function (resp) {
	$.getJSON(resp.url, function (o) {
	  $.getJSON(o.transaction.url, function (o) {
	    page_vm.transactions.push(o);
	  });
	});
      });
    };

    applyManyBindings({
      'transactions': page_vm,
      'modal-associate': associate_vm,
      'modal-add-invoice' : add_invoice_vm
    });
  }

  init_on_page('transactions', init);
})();

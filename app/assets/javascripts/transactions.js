(function () {
  function init() {
    var styles = {
      'open' : 'panel-success',
      'closed' : 'panel-info'
    };

    var documents_cache = _.map(documents, function (o) {
      return {
	id: o.id,
	content: ko.observable()
      };
    });

    function with_document_content(id, fn) {
      var o = _.find(documents_cache, function (doc) {
	return id === doc.id;
      });

      if (o) {
	fn(o.content);
      }
    }

    var page_vm = {
      transactions: ko.observableArray(transactions),
      invoices: ko.observableArray(invoices),
      modals: {
	associate: {
	  rules: ko.observableArray(),
	  transformations: ko.observableArray()
	}
      }
    };

    function send_event(t, args, fn) {
      var evt = {
	event_type: t,
	payload: args
      };
      $.post(Routes.api_v1_events_path(), evt, function (o) {
	$.getJSON(o.url, function (e) {
	  if (fn) {
	    fn(e);
	  } else {
	    console.log(e);
	  }
	});
      });
    }
    
    function make_invoice_vm(invoice) {
      var vm = {
	id: invoice.id,
	content: ko.computed(function () {
	  var rv = null;
	  if (invoice) {
	    var last = _.last(invoice.revisions);
	    if (last) {
	      with_document_content(last.document.id, function (content) {
		rv = content();
	      });
	    }
	  }

	  return rv;
	})
      };

      vm.destroy = function () {
	send_event('invoice_destroy', { invoice_id: invoice.id }, function () {
	  page_vm.invoices.remove(function (o) {
	    return o.id === invoice.id;
	  });
	});
      };

      vm.format_url = ko.computed(function () {
	return invoice ? Routes.api_v1_invoice_path(invoice.id) : '';
      });
      
      return vm;
    }

    function make_association_vm(o) {
      return o;
    }
    
    function make_item_vm(tr) {
      var vm = {
	panel_style: _.get(styles, tr.status, 'panel-info'),
	status_label: _.get(labels, tr.status),
	// overrides of base properties
	invoices: ko.computed(function () {
	  var all_invoices = page_vm.invoices();

	  return _.reduce(tr.invoices, function (a, o) {
	    var invoice_vm = _.find(all_invoices, function (invoice) {
	      return o.id === invoice.id;
	    });

	    var rv = invoice_vm ? _.concat(a, make_invoice_vm(invoice_vm)) : a;
	    return rv;
	  }, []);
	}),
	associations: ko.observableArray(_.map(tr.associations, make_association_vm)),
	source: ko.observable(tr.source)
      };

      vm.have_invoices = ko.computed(function () {
	return vm.invoices().length > 0;
      });

      vm.have_associations = ko.computed(function () {
	return vm.associations().length > 0;
      });

      // triggers
      vm.trigger_associate = function (o) {
	debugger;
      };
      
      vm.trigger_execute = function (o) {
	send_event('transaction_execute', { transaction_id: tr.id });
      };
      
      vm.trigger_close = function (o) {
	send_event('transaction_close', { transaction_id: tr.id }, function (e) {
	  page_vm.transactions.remove(function (o) {
	    return o.id === tr.id;
	  });
	  $.getJSON(e.transaction.url, function (ntr) {
	    page_vm.transactions.push(ntr);
	  });
	});
      };
      
      vm.trigger_add_invoice = function (o) {
	debugger;
      };
      
      vm.trigger_bind_source = function (o) {
	debugger;
      };
      
      vm.trigger_tradeshift_sync = function (o) {
	send_event('tradeshift_sync', { user_id: user_id });
      };

      return vm;
    }

    page_vm.transaction_parts = ko.computed(function () {
      return _.chunk(_.map(page_vm.transactions(), make_item_vm), 2);
    });

    page_vm.add = function () {
      $.post(Routes.api_v1_events_path(), {
	event_type: 'transaction_open',
	payload: { user_id: user_id }
      }, function (resp) {
	$.getJSON(resp.url, function (o) {
	  $.getJSON(o.transaction.url, function (o) {
	    page_vm.transactions.push(o);
	  });
	});
      });
    };

    // download associated objects
    _.each(documents, function (document) {
      $.getJSON(document.url, function (content) {
	with_document_content(document.id, function (doc_content) {
	  doc_content(content);
	});
      });
    });

    $.getJSON(Routes.api_v1_rules_path(), function (o) {
      page_vm.modals.associate.rules(o);
    });

    $.getJSON(Routes.api_v1_transformations_path(), function (o) {
      page_vm.modals.associate.transformations(o);
    });

    ko.applyBindings(page_vm, document.getElementById('page'));    
  }

  init_on_page('transactions', init);
})();

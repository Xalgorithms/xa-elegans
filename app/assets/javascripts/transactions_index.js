(function () {
  function init() {
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

      var content = ko.observable();
      if (o) {
	content = o.content;
      } else {
	documents_cache.push({ id: id, content: content });
      }
      fn(content);
    }

    var page_vm = {
      transactions: ko.observableArray(transactions),
      invoices: ko.observableArray(invoices),
      modals: {
	associate: {
	  active: ko.observable(false),
	  rules: ko.observableArray(rules),
	  transformations: ko.observableArray(transformations),
	  rule_id: ko.observable(),
	  transformation_id: ko.observable()
	},
	add_invoice: {
	  active: ko.observable(false),
	  url: ko.observable('https://raw.githubusercontent.com/Xalgorithms/xa-elegans/master/ubl/documents/icelandic-guitar/t0.xml')
	},
	bind_source: {
	  active: ko.observable(false),
	  source: ko.observable()
	}
      }
    };

    page_vm.modals.associate.deactivate = function () {
      page_vm.modals.associate.active(false);
    };

    page_vm.modals.associate.send = function () {
      var m = page_vm.modals.associate;
      send_event('transaction_associate_rule', {
	transaction_id: m.transaction_id,
	rule_id: m.rule_id(),
	transformation_id: m.transformation_id()
      }, function (e) {
	recycle_transaction(e.transaction.id, e.transaction.url);
      });
      
      page_vm.modals.associate.active(false);      
    };

    page_vm.modals.add_invoice.deactivate = function () {
      page_vm.modals.add_invoice.active(false);
    };

    page_vm.modals.add_invoice.send = function () {
      var m = page_vm.modals.add_invoice;
      send_event('transaction_add_invoice', {
	transaction_id: m.transaction_id,
	url: m.url()
      }, function (e) {
	recycle_transaction(e.transaction.id, e.transaction.url, function () {
	  $.getJSON(e.invoice.url, function (invoice) {
	    page_vm.invoices.push(invoice);
	  });
	  $.getJSON(e.document.url, function (content) {
	    with_document_content(e.document.id, function (doc_content) {
	      doc_content(content);
	    });
	  });
	});
      });

      page_vm.modals.add_invoice.active(false);
    };

    page_vm.modals.bind_source.deactivate = function () {
      page_vm.modals.bind_source.active(false);
    };

    page_vm.modals.bind_source.send = function () {
      var m = page_vm.modals.bind_source;
      send_event('transaction_bind_source', {
	transaction_id: m.transaction_id,
	source: m.source()
      }, function (e) {
	recycle_transaction(e.transaction.id, e.transaction.url);
      });

      page_vm.modals.bind_source.active(false);
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

    function recycle_transaction(id, url, fn) {
      var otr = _.find(page_vm.transactions(), function (o) {
	return o.id === id;
      });

      if (otr) {
	$.getJSON(url, function (ntr) {
	  page_vm.transactions.replace(otr, ntr);
	  if (fn) {
	    fn();
	  }
	});
      }
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
      return {
	name: o.transformation.name,
	reference: o.rule.reference,
	destroy: function () {
	}
      };
    }
    
    function make_item_vm(tr) {
      var vm = {
	active_section: ko.observable('invoices'),
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

      vm.invoice_parts = ko.computed(function () {
	return _.chunk(vm.invoices(), 3);
      });
      
      vm.association_parts = ko.computed(function () {
	return _.chunk(vm.associations(), 1);
      });

      vm.is_invoices_active = ko.computed(function() {
	return vm.active_section() === 'invoices';
      });

      vm.is_associations_active = ko.computed(function() {
	return vm.active_section() === 'associations';
      });

      vm.activate_invoices = function () {
	vm.active_section('invoices');
      };

      vm.activate_associations = function () {
	vm.active_section('associations');
      };
      
      vm.have_invoices = ko.computed(function () {
	return vm.invoices().length > 0;
      });

      vm.have_associations = ko.computed(function () {
	return vm.associations().length > 0;
      });

      // triggers
      vm.trigger_associate = function (o) {
	page_vm.modals.associate.transaction_id = tr.id;
	page_vm.modals.associate.active(true);
      };
      
      vm.trigger_execute = function (o) {
	send_event('transaction_execute', { transaction_id: tr.id });
      };
      
      vm.trigger_add_invoice = function (o) {
	page_vm.modals.add_invoice.transaction_id = tr.id;
	page_vm.modals.add_invoice.active(true);
      };
      
      vm.trigger_bind_source = function (o) {
	page_vm.modals.bind_source.transaction_id = tr.id;	
	page_vm.modals.bind_source.active(true);
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

    ko.applyBindings(page_vm, document.getElementById('page'));    
  }

  define_on_page('transactions', 'index', init);
})();

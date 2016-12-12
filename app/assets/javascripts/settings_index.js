(function () {
  function save_user_settings(vals, fn) {
    var evt = {
      event_type: 'settings_update',
      payload: _.extend(vals, { user_id: user_id })
    };
    $.post(Routes.api_v1_events_path(), evt, function (o) {
      fn();
    });
  }
  
  function init() {
    var page_vm = {
      section: ko.observable(default_section),
      message: ko.observable()
    };

    var base_vms = {};

    var save_success = function () {
      page_vm.message('Saved');
    };
    
    page_vm.have_message = ko.computed(function() {
      return !_.isEmpty(page_vm.message());
    });

    page_vm.clear_message = function () {
      page_vm.message('');
    };
    
    page_vm.section_clicked = function (vm, e) {
      var target = $(e.currentTarget).data('target');
      if (_.has(page_vm.vms[target], 'activated')) {
	page_vm.vms[target].activated();
      }
      page_vm.section(target);
    };

    base_vms.tradeshift = {
      activated: function () {
	$.getJSON(Routes.api_v1_user_settings_path(user_id), function (o) {
	  if (_.has(o, 'tradeshift')) {
	    console.log('updating tradeshift');
	    base_vms.tradeshift.key(o.tradeshift.key);
	    base_vms.tradeshift.secret(o.tradeshift.secret);
	    base_vms.tradeshift.tenant_id(o.tradeshift.tenant_id);
	  }
	});
      },
      save: function () {
	var vals = {
	  tradeshift: {
	    key: base_vms.tradeshift.key(),
	    secret: base_vms.tradeshift.secret(),
	    tenant_id: base_vms.tradeshift.tenant_id()
	  }
	};
	save_user_settings(vals, save_success);
      },
      key: ko.observable(),
      secret: ko.observable(),
      tenant_id: ko.observable()
    };
    
    page_vm['vms'] = _.reduce(sections, function (o, name) {
      var base_vm = _.get(base_vms, name, {});
      return _.set(o, name, _.extend(base_vm, {
	name: name,
        visible: ko.computed(function() {
          return page_vm.section() === name;
        }),
        active: ko.computed(function () {
          return page_vm.section() === name;
        })
      }));
    }, {});

    ko.applyBindings(page_vm, document.getElementById('page'));
  }

  define_on_page('settings', 'index', init);
})();

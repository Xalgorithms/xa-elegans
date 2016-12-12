(function () {
  function init() {
    var page_vm = {
      transformations: ko.observableArray(transformations),
      modals: {
	add_transformation: {
	  active: ko.observable(false),
	  name: ko.observable(),
	  src: ko.observable()
	}
      }
    };

    page_vm.modals.add_transformation.deactivate = function() {
      page_vm.modals.add_transformation.active(false);
    };

    page_vm.modals.add_transformation.send = function() {
      page_vm.modals.add_transformation.active(false);
      
      var evt = {
	event_type: 'transformation_add',
	payload: {
	  name: page_vm.modals.add_transformation.name(),
	  src: page_vm.modals.add_transformation.src()
	}
      };

      $.post(Routes.api_v1_events_path(), evt, function (o) {
	$.getJSON(o.url, function (o) {
          $.getJSON(o.transformation.url, function (tx) {
	    page_vm.transformations.push(tx);
          });
	});
      });
    };

    function make_item_vm(o) {
      return {
	name: o.name,
	destroy: function () {
          $.post(Routes.api_v1_events_path(), {
	    event_type: 'transformation_destroy',
	    payload: { transformation_id: o.id }
          }, function (resp) {
	    $.getJSON(resp.url, function (evt) {
              page_vm.transformations.remove(function (it) {
                return it.id == evt.transformation.id;
              });
            });
          });
	},
	format_url: ko.computed(function () {
          return Routes.api_v1_transformation_path(o.id);
        }),
	not_in_use: ko.computed(function () {
	  return in_use[o.id] == 0;
	})
      };
    }

    page_vm.transformation_parts = ko.computed(function () {
      return _.chunk(_.map(page_vm.transformations(), make_item_vm), 4);
    });

    page_vm.format_url = function (o) {
      return "foo";
    };

    page_vm.activate_add_modal = function () {
      page_vm.modals.add_transformation.active(true);
    };

    ko.applyBindings(page_vm, document.getElementById('page'));
  }

  define_on_page('transformations', 'index', init);
})();

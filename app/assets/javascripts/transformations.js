function make_item_vm(o) {
  return _.extend(o, {
    destroy: function () {
      $.post(Routes.api_v1_events_path(), {
	event_type: 'transformation_destroy',
	transformation_destroy_event: { public_id: o.id }
      }, function (resp) {
	   $.getJSON(resp.url, function (evt) {
             vm.transformations.remove(function (it) {
               return it.id == evt.transformation.id;
             });
           });
      });
    },
    format_url: ko.computed(function () {
      return Routes.api_v1_transformation_path(o.id);
    })
  });
}

function init() {
  console.log('transformations: init');

  $('.new_transformation_add_event').on('ajax:success', function (e, o) {
    $('#modal-add-transformation').modal('toggle');
    $.getJSON(o.url, function (o) {
      $.getJSON(o.transformation.url, function (tx) {
	vm.transformations.push(tx);
      });
    });
  });

  vm.transformation_parts = ko.computed(function () {
    return _.chunk(_.map(vm.transformations(), make_item_vm), 4);
  });

  vm.format_url = function (o) {
    return "foo";
  };
  
  ko.applyBindings(vm, document.getElementById('transformations'));
}

init_on_page('transformations', init);

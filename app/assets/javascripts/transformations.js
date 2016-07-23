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
    return _.chunk(vm.transformations(), 4);
  });
  
  ko.applyBindings(vm, document.getElementById('transformations'));
}

init_on_page('transformations', init);

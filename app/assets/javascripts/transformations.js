function init() {
  console.log('transformations: init');

  $('.new_transformation_add_event').on('ajax:success', function (e, o) {
    console.log(o);
  });

  vm.transformation_parts = ko.computed(function () {
    return _.chunk(vm.transformations(), 4);
  });
  
  ko.applyBindings(vm, document.getElementById('transformations'));
}

init_on_page('transformations', init);

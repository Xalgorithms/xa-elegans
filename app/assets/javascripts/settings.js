(function () {
  function init() {
    console.log('settings: init');

    var page_vm = {
      section: ko.observable(default_section),
      vms: {}
    };

    _.each(sections, function (name) {
      var is_name = 'is_' + name;

      page_vm.vms[name] = {};
      page_vm[is_name] = ko.computed(function () {
	return page_vm.section() === name;
      });
      page_vm[name + '_active'] = ko.computed(function () {
	return page_vm[is_name]() ? 'active' : '';
      });
    });
    
    page_vm.section_clicked = function (vm, e) {
      var target = $(e.currentTarget).data('target');
      page_vm.section(target);
    };
    
    applyManyBindings(
      _.extend(page_vm.vms, { page: page_vm })
    );
  }

  init_on_page('settings', init);
})();

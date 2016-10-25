(function () {
  function init() {
    console.log('settings: init');

    var tradeshift_vm = {
    };

    var general_vm = {
    };

    var page_vm = {
      section: ko.observable('tradeshift')
    };

    page_vm.section_clicked = function (vm, e) {
      var target = $(e.currentTarget).data('target');
      page_vm.section(target);
    };
    
    page_vm.is_general = ko.computed(function () {
      return page_vm.section() == 'general';
    });
    page_vm.general_active = ko.computed(function () {
	return page_vm.is_general() ? 'active' : '';
    });
    
    page_vm.is_tradeshift = ko.computed(function () {
      return page_vm.section() == 'tradeshift';
    });
    page_vm.tradeshift_active = ko.computed(function () {
	return page_vm.is_tradeshift() ? 'active' : '';
    });

    applyManyBindings({
      'page': page_vm,
      'tradeshift' : tradeshift_vm,
      'general' : general_vm
    });
  }

  init_on_page('settings', init);
})();

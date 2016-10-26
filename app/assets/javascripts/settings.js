(function () {
  function init() {
    var page_vm = {
      section: ko.observable(default_section)
    };
    
    page_vm['vms'] = _.reduce(sections, function (o, name) {
      return _.set(o, name, {
	name: name,
        visible: ko.computed(function() {
          return page_vm.section() === name;
        }),
        active: ko.computed(function () {
          return page_vm.section() === name ? 'active' : '';
        })
      });
    }, {});

    page_vm.section_clicked = function (vm, e) {
      var target = $(e.currentTarget).data('target');
      page_vm.section(target);
    };

    ko.applyBindings(page_vm, document.getElementById('page'));
  }

  init_on_page('settings', init);
})();

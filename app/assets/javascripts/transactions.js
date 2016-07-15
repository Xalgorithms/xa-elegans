function find_version_select(id_el) {
  return $('.select_rule_version', id_el.closest('.row'));
}

function update_versions_for_selected_rule(el) {
  var sel_id = el.val();
  var ver_el = find_version_select(el);

  ver_el.removeClass('hidden');
  ver_el.empty();

  var rule = _.find(rules, function (rule) {
    return rule.id === sel_id;
  });

  _.each(rule.versions, function (ver) {
    ver_el.append(new Option(ver, ver));
  });
}

function init() {
  $('.select_rule_id').on('change', function (e) {
    update_versions_for_selected_rule($(this));
  });
  $('.select_rule_id').each(function (i, el) {
    update_versions_for_selected_rule($(el));
  });
}

init_on_page('transactions', init);
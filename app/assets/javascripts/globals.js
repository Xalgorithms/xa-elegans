var pages = { };

function define_on_page(name, action, init_fn) {
  var k = name + '_' + action;
  pages = _.set(pages, k, init_fn);
}

function init_on_page(name, action) {
  var k = name + '_' + action;
  var init_fn = _.get(pages, k, null);
  if (init_fn) {
    console.log('init: ' + name + '/' + action);
    init_fn();
  } else {
    console.log('missing: ' + name + '/' + action);
  }
}


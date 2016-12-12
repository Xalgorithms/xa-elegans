var pages = { };

function define_on_page(name, action, init_fn) {
  pages = _.set(pages, `${name}_${action}`, init_fn);
}

function init_on_page(name, action) {
  var init_fn = _.get(pages, `${name}_${action}`, null);
  if (init_fn) {
    console.log(`init: ${name}/${action}`);
    init_fn();
  } else {
    console.log(`missing: ${name}/${action}`);
  }
}

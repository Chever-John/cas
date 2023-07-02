# quite an "unused variable" warning from shellcheck and
# also document your code
function cas::util::sourced_variable {
  true
}

cas::util::sortable_date() {
  date "+%Y%m%d-%H%M%S"
}


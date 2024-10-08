setup_file() {
  load '_common.bash'
  _common_setup
}

teardown_file() {
  load '_common.bash'
  _common_teardown
}

@test "install from directory" {
  load '_common.bash'
  _common_test_install
}

@test "ddev poser without composer.json" {
  load '_common.bash'
  rm -f composer.json
  _common_test_poser
}

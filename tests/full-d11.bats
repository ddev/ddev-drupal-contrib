setup_file() {
  export TEST_DRUPAL_CORE=11
  load '_common.bash'
  _common_setup
  ddev config --php-version=8.3 --corepack-enable
}

teardown_file() {
  load '_common.bash'
  _common_teardown
}

@test "install from directory" {
  load '_common.bash'
  _common_test_install
}

@test "ddev poser with composer.json" {
  load '_common.bash'
  _common_test_poser
}

@test "ddev symlink-project" {
  load '_common.bash'
  _common_test_symlink
}

@test "php tools availability" {
  load '_common.bash'
  _common_test_php
}

@test "drupal core version" {
  load '_common.bash'
  _common_test_drupal_version
}

@test "node tools availability" {
  load '_common.bash'
  _common_test_node
}

setup_file() {
  if [ -z "$TEST_DRUPAL_CORE" ]; then
    echo "TEST_DRUPAL_CORE is necessary to run tests" >&2
    exit 1
  fi
  if [ "$TEST_DRUPAL_CORE" != "10" ] && [ "$TEST_DRUPAL_CORE" != "11"  ]; then
    skip "TEST_DRUPAL_CORE=$TEST_DRUPAL_CORE not handled by this test suite" >&2
  fi
  load '_common.bash'
  _common_setup
  ddev config --php-version=8.2
  if [ "$TEST_DRUPAL_CORE" = "11" ]; then
    ddev config --php-version=8.3 --corepack-enable
  fi
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

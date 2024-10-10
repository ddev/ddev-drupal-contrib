setup_file() {
  if [ -z "$TEST_DRUPAL_CORE" ]; then
    echo "TEST_DRUPAL_CORE is necessary to run tests" >&2
    exit 1
  fi
  if [ "$TEST_DRUPAL_CORE" != "default" ]; then
    skip "TEST_DRUPAL_CORE=$TEST_DRUPAL_CORE not handled by this test suite" >&2
  fi
  load '_common.bash'
  _common_setup
  ddev start
}

teardown_file() {
  load '_common.bash'
  _common_teardown
}

@test "ddev poser without composer.json" {
  load '_common.bash'
  rm -f composer.json
  _common_test_poser
}
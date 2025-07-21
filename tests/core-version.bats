load helpers/bats-support/load.bash
load helpers/bats-assert/load.bash

setup_file() {
  if [ -n "$TEST_DRUPAL_CORE" ] && [ "$TEST_DRUPAL_CORE" != "default" ]; then
    skip "TEST_DRUPAL_CORE=$TEST_DRUPAL_CORE not handled by this test suite" >&2
  fi
  load '_common.bash'
  _common_setup
  ddev start
  _common_test_poser
}

teardown_file() {
  load '_common.bash'
  _common_teardown
}

@test "ddev core-version ^10" {
  ddev core-version ^10
  run -0 ddev exec 'drush st --fields=drupal-version --format=string | cut -d. -f1'
  assert_output "10"
}

@test "ddev core-version ^11" {
  ddev core-version ^11
  run -0 ddev exec 'drush st --fields=drupal-version --format=string | cut -d. -f1'
  assert_output "11"
}

@test "ddev core-version default" {
  ddev core-version default
  run -0 ddev exec 'drush st --fields=drupal-version --format=string | cut -d. -f1'
  assert_output "11"
}

@test "ddev core-version <none>" {
  ddev core-version
  run -0 ddev exec 'drush st --fields=drupal-version --format=string | cut -d. -f1'
  assert_output "11"
}

@test "ddev core-version short-major" {
  ddev core-version 11
  run -0 ddev exec 'drush st --fields=drupal-version --format=string'
  assert_output "11.0.0"
}

@test "ddev core-version invalid" {
  run ! ddev core-version test
  assert_output --partial 'Could not parse version constraint test: Invalid version string "test"'
}

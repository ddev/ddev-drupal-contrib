load helpers/bats-support/load.bash
load helpers/bats-assert/load.bash

setup_file() {
  if [ -n "$TEST_DRUPAL_CORE" ] && [ "$TEST_DRUPAL_CORE" != "10" ] && [ "$TEST_DRUPAL_CORE" != "11"  ]; then
    skip "TEST_DRUPAL_CORE=$TEST_DRUPAL_CORE not handled by this test suite" >&2
  fi
  load '_common.bash'
  _common_setup
  ddev config --php-version=8.2
  if [ "$TEST_DRUPAL_CORE" = "11" ]; then
    ddev config --php-version=8.3 --corepack-enable
  fi
  ddev start
}

teardown_file() {
  load '_common.bash'
  _common_teardown
}

@test "ddev poser with composer.json" {
  load '_common.bash'
  _common_test_poser
}

@test "ddev symlink-project" {
  ddev symlink-project
  ddev mutagen sync
  ls -la web/modules/custom/test_drupal_contrib/test_drupal_contrib.info.yml
}

@test "php tools availability" {
  ddev phpcs --version
  ddev phpstan --version
  ddev phpunit --version
}

@test "drupal core version" {
  run -0 ddev exec 'drush st --fields=drupal-version --format=string | cut -d. -f1'
  if [ -n "${TEST_DRUPAL_CORE}" ]; then
    assert_output "${TEST_DRUPAL_CORE}"
  else
    DDEV_DRUPAL_CORE=$(ddev exec 'echo "${DRUPAL_CORE/^/}"')
    assert_output "$DDEV_DRUPAL_CORE"
  fi
}

@test "node tools availability" {
  ddev exec "cd web/core && yarn install"
  ddev exec touch web/core/.env
  ddev mutagen sync
  ddev stylelint --version
  ddev eslint --version
}

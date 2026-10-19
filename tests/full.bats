load helpers/bats-support/load.bash
load helpers/bats-assert/load.bash

setup_file() {
  if [ -n "$TEST_DRUPAL_CORE" ] && [ "$TEST_DRUPAL_CORE" != "10" ] && [ "$TEST_DRUPAL_CORE" != "11"  ]; then
    skip "TEST_DRUPAL_CORE=$TEST_DRUPAL_CORE not handled by this test suite" >&2
  fi
  load '_common.bash'
  _common_setup
  if [ "$TEST_DRUPAL_CORE" = "10" ]; then
    # Test D10 with older PHP version and corepack-disabled
    ddev config --php-version=8.2 --corepack-enable=false
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

@test "ddev symlink-project creates gitignore only when missing" {
  rm -f .gitignore
  ddev mutagen sync
  run -0 ddev symlink-project
  ddev mutagen sync
  run -0 grep -Fx "/vendor/" .gitignore
  run -0 grep -Fx "/web/" .gitignore

  echo "/custom/" > .gitignore
  ddev mutagen sync
  run -0 ddev symlink-project
  ddev mutagen sync
  run -0 cat .gitignore
  assert_output "/custom/"
}

@test "php tools availability" {
  ddev phpcs --version
  ddev phpstan --version
  ddev phpunit --version
}

@test "phpstan uses the project root configuration" {
  # Simulate the broken relative link created by earlier versions.
  ddev exec ln -sfn web/phpstan.neon web/modules/custom/test_drupal_contrib/phpstan.neon
  run ddev phpstan --no-progress
  assert_output --partial "Using configuration file"
  run -0 ddev exec readlink web/modules/custom/test_drupal_contrib/phpstan.neon
  assert_output "/var/www/html/phpstan.neon"
  run -0 ddev exec readlink web/modules/custom/test_drupal_contrib/phpstan-baseline.neon
  assert_output "/var/www/html/phpstan-baseline.neon"
}

@test "drupal core version" {
  run -0 ddev exec 'drush st --fields=drupal-version --format=string | cut -d. -f1'
  # Default core version is ^11.
  assert_output "${TEST_DRUPAL_CORE:-11}"
}

@test "node tools availability" {
  ddev exec "cd web/core && yarn install"
  ddev exec touch web/core/.env
  ddev mutagen sync
  ddev stylelint --version
  ddev eslint --version
}

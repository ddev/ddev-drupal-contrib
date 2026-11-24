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

@test "ddev phpcs and phpcbf scan only the given paths" {
  mkdir phpcs_test
  printf '<?php\n$one=1;\n' > phpcs_test/one.php
  printf '<?php\n$two=2;\n' > phpcs_test/two.php
  ddev symlink-project
  ddev mutagen sync

  run ddev phpcs
  assert_output --partial "/one.php"
  assert_output --partial "/two.php"

  run ddev phpcs -n
  assert_output --partial "/one.php"
  assert_output --partial "/two.php"

  run ddev phpcs -n phpcs_test/one.php
  assert_output --partial "/one.php"
  refute_output --partial "/two.php"

  run ddev phpcbf phpcs_test/one.php
  ddev mutagen sync
  run -0 grep -F '$one = 1;' phpcs_test/one.php
  run -0 grep -F '$two=2;' phpcs_test/two.php

  rm -r phpcs_test web/modules/custom/test_drupal_contrib/phpcs_test
  ddev mutagen sync
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

setup_file() {
  load '_common.bash'
  _common_setup
  ddev config --php-version=8.3 --corepack-enable
  echo -e "web_environment:\n    - DRUPAL_CORE=^11" > .ddev/config.~overrides.yaml
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

@test "require-dev availability" {
  load '_common.bash'
  _common_test_require_dev
}

@test "node tools availability" {
  load '_common.bash'
  _common_test_node
}

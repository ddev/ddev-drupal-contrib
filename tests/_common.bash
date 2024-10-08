#!/usr/bin/env bash

_common_setup() {
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export PROJNAME=test-drupal-contrib
  export TESTDIR=~/tmp/${PROJNAME}
  mkdir -p $TESTDIR
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
  cp -R ${DIR}/tests/testdata/test_drupal_contrib/* ${TESTDIR}
  cd ${TESTDIR}
  ddev config  --project-name=${PROJNAME} --project-type=drupal --docroot=web
}

_common_teardown() {
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

_common_test_install() {
  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${DIR}
  ddev start
}

_common_test_poser() {
  ddev poser
  ddev mutagen sync
  ls -la
}

_common_test_symlink() {
  ddev symlink-project
  ddev mutagen sync
  ls -la web/modules/custom/test_drupal_contrib/test_drupal_contrib.info.yml
}

_common_test_php() {
  ddev phpcs --version
  ddev phpstan --version
  ddev phpunit --version
}

_common_test_require_dev() {
  ddev drush st
}

_common_test_node() {
  ddev exec "cd web/core && yarn install"
  ddev exec touch web/core/.env
  ddev mutagen sync
  ddev stylelint --version
  ddev eslint --version
}

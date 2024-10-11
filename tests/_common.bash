#!/usr/bin/env bash

_common_setup() {
  bats_require_minimum_version 1.5.0
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export PROJNAME=test-drupal-contrib
  export TESTDIR=~/tmp/${PROJNAME}
  mkdir -p $TESTDIR
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
  cp -R ${DIR}/tests/testdata/test_drupal_contrib/* ${TESTDIR}
  cd ${TESTDIR}
  ddev config  --project-name=${PROJNAME} --project-type=drupal --docroot=web
  if [ -n "$TEST_DRUPAL_CORE" ] && [ "$TEST_DRUPAL_CORE" != "default" ]; then
    echo -e "web_environment:\n    - DRUPAL_CORE=^${TEST_DRUPAL_CORE}" > .ddev/config.~overrides.yaml
  fi
  ddev get ${DIR}
}

_common_teardown() {
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

_common_test_poser() {
  ddev poser
  ddev mutagen sync
  ls -la web/core
  ls -la vendor/
  ls -la
}

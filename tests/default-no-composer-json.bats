setup_file() {
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export PROJNAME=test-drupal-contrib
  export TESTDIR=~/tmp/${PROJNAME}
  mkdir -p $TESTDIR
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
  cp -R ${DIR}/tests/testdata/test_drupal_contrib/* ${TESTDIR}
  cd ${TESTDIR}
  ddev config  --project-name=${PROJNAME} --project-type=drupal --docroot=web --php-version=8.3
}

teardown_file() {
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "install from directory" {
  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR}/${PROJNAME} ($(pwd))" >&3f
  ddev get ${DIR}
  ddev start
}

@test "ddev poser without composer.json" {
  rm -f composer.json
  ddev poser
}

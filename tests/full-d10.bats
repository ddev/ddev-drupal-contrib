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
  echo -e "web_environment:\n    - DRUPAL_CORE=^10" > .ddev/config.~overrides.yaml
}

teardown_file() {
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "install from directory" {
  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR} ($(pwd))" >&3
  ddev get ${DIR}
}

@test "ddev start" {
  ddev start
}

@test "ddev poser with composer.json" {
  ddev poser
  ddev mutagen sync
  ls -la
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

@test "node tools availability" {
  ddev exec "cd web/core && yarn install"
  ddev exec touch web/core/.env
  ddev mutagen sync
  ddev stylelint --version
  ddev eslint --version
}

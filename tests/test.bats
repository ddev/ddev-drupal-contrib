setup() {
  set -eu -o pipefail
  export DIR="$( cd "$( dirname "$BATS_TEST_FILENAME" )" >/dev/null 2>&1 && pwd )/.."
  export TESTDIR=~/tmp/test-addon-template
  mkdir -p $TESTDIR
  export PROJNAME=keycdn
  export DDEV_NON_INTERACTIVE=true
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1 || true
  cd "${TESTDIR}"
  git clone https://git.drupalcode.org/project/keycdn.git
}

health_checks() {
  ddev expand-composer-json
  composer install
  ddev drush st
  ddev phpcs
  ls -al web/modules/custom/${PROJNAME}/tests
  ddev phpunit --stop-on-failure
}

teardown() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "install from directory" {
  set -eu -o pipefail
  cd ${TESTDIR}/keycdn
  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR}/keycdn ($(pwd))" >&3
  ddev get ${DIR}
  ddev start
  health_checks
}
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

teardown() {
  set -eu -o pipefail
  cd ${TESTDIR} || ( printf "unable to cd to ${TESTDIR}\n" && exit 1 )
  ddev delete -Oy ${PROJNAME} >/dev/null 2>&1
  [ "${TESTDIR}" != "" ] && rm -rf ${TESTDIR}
}

@test "install from directory" {
  set -eu -o pipefail
  cd ${TESTDIR}/${PROJNAME}
  echo "# ddev get ${DIR} with project ${PROJNAME} in ${TESTDIR}/${PROJNAME} ($(pwd))" >&3
  ddev get ${DIR}
  ddev start
  ddev expand-composer-json
  composer install
  ddev symlink-project
  ddev drush st
  ddev phpcs --version
  ls -al web/modules/custom/${PROJNAME}/tests
  ddev phpunit --version
  ddev yarn --cwd web/core install
  ddev exec touch web/core/.env
  ddev stylelint --version
  ddev eslint --version
}
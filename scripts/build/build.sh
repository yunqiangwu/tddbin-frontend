#!/bin/bash

if [ -z "${KATAS_SERVICE_URL:+x}" ]; then
  echo "Can not build. Environment variable 'KATAS_SERVICE_URL' must be set";
  exit 1;
fi;

# TODO: must be run from project root (i am sure this is not bash best pratice)

ORIGIN_ROOT="."
DIST_ROOT="$ORIGIN_ROOT/dist"
DIST_MOCHA_DIR="$DIST_ROOT/mocha"
DIST_JASMINE_DIR="$DIST_ROOT/jasmine"
DIST_KATAS_DIR="$DIST_ROOT/katas"

# clean up
rm -Rf $DIST_ROOT;

# create build directory (structure)
mkdir -p $DIST_MOCHA_DIR;
mkdir -p $DIST_JASMINE_DIR;
mkdir -p $DIST_KATAS_DIR;

# copy html assets
cp $ORIGIN_ROOT/src/_html/index.html $DIST_ROOT;
# replace place holder KATAS_SERVICE_URL with env var, so it can be different in dev/prod mode
KATAS_SERVICE_URL_ESCAPED_FOR_SED=$(sed -e 's/[\/&]/\\&/g' <<< ${KATAS_SERVICE_URL})
if [[ $OSTYPE == darwin* ]]; then
  sed -i'' "s/\${KATAS_SERVICE_URL}/$KATAS_SERVICE_URL_ESCAPED_FOR_SED/g" $DIST_ROOT/index.html
else
  sed -i "s/\${KATAS_SERVICE_URL}/$KATAS_SERVICE_URL_ESCAPED_FOR_SED/g" $DIST_ROOT/index.html
fi;

cp $ORIGIN_ROOT/src/_html/favicon.ico $DIST_ROOT;
cp $ORIGIN_ROOT/src/test-runner/mocha/spec-runner.html $DIST_MOCHA_DIR;
cp $ORIGIN_ROOT/src/test-runner/jasmine/spec-runner.html $DIST_JASMINE_DIR;
cp $ORIGIN_ROOT/src/test-runner/katas/spec-runner.html $DIST_KATAS_DIR;

# run all build scripts, `&&` ensures to stop on any fail
(
  npm run build:app &&
  npm run build:css &&
  npm run build:ace &&
  npm run build:spec-runners
)
# cp $ORIGIN_ROOT/CNAME $DIST_ROOT/CNAME;

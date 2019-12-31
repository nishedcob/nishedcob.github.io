#! /bin/bash

EXT_PATH=${EXT_PATH:-"/tmp"}
REPO_PATH=${REPO_PATH:-"/home/nyx/nishedcob.github.io"}

echo " EXT_PATH=$EXT_PATH"
echo "REPO_PATH=$REPO_PATH"

cp -v $EXT_PATH/Makefile $REPO_PATH/ || (git clean -f . ; exit 1)
cp -v $EXT_PATH/Dockerfile $REPO_PATH/ || (git clean -f . ; exit 2)
cp -v $EXT_PATH/.dockerignore $REPO_PATH/ || (git clean -f . ; exit 3)

cd $REPO_PATH

make build || (git clean -f . ; exit 4)

make clean || (git clean -f . ; exit 5)

git clean -f .

exit 0

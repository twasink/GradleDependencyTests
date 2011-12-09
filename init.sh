#!/bin/bash

git submodule init
git submodule update
pushd gradle
./gradlew install -Pgradle_installPath=../gradle_build
popd


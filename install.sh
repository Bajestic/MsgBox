#!/bin/bash

SRC_DIR=$(pwd)
BUILD_DIR=../build

# Add user aliases (my cmake 3.27 version too)
shopt -s expand_aliases
source ~/.bashrc

# cmake 3.22 doesn't work (generate cmake files in src directory)
cmake -B${BUILD_DIR} -S${SRC_DIR} ${SRC_DIR}/CMakeLists.txt
# TODO: check if symbolic link exist
ln -s ${BUILD_DIR}/compile_commands.json ${SRC_DIR}git ad
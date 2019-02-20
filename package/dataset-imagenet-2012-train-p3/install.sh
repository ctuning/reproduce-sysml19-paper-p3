#! /bin/bash

#
# Installation script for the 2012 ImageNet Large Scale Visual Recognition
# Preparing (ILSVRC'12) train dataset for MXNet
#
# See CK LICENSE for licensing details.
# See CK COPYRIGHT for copyright details.
#
# Developer(s):
# - Grigori Fursin, Grigori.Fursin@cTuning.org, 2019

# PACKAGE_DIR
# INSTALL_DIR

cd ${INSTALL_DIR}
mkdir install
cd install

DATA_DIR="${CK_ENV_DATASET_IMAGENET_TRAIN}"

"${CK_ENV_COMPILER_PYTHON_FILE}" "${CK_ENV_TOOL_SYSML19_P3}/tools/im2rec.py" --list --recursive --train-ratio 0.95 imagenet1k $DATA_DIR
if [ "${?}" != "0" ] ; then
  echo "Error: error processing ImageNet for P3!"
  exit 1
fi

"${CK_ENV_COMPILER_PYTHON_FILE}" "${CK_ENV_TOOL_SYSML19_P3}/tools/im2rec.py" --resize 480 --quality 95 --num-thread ${NUM_THREADS} imagenet1k $DATA_DIR
if [ "${?}" != "0" ] ; then
  echo "Error: error processing ImageNet for P3!"
  exit 1
fi

#####################################################################
echo ""
echo "Successfully processed ILSVRC'12 train dataset for MXNet ..."
exit 0

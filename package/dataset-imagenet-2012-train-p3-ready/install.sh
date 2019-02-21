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

# Clean install
if [ -f "${PACKAGE_NAME1}" ]; then
  echo ""
  echo "Cleaning ${INSTALL_DIR}/${PACKAGE_NAME1} file ..."
  echo ""
  rm -f ${PACKAGE_NAME1}
fi
if [ -f "${PACKAGE_NAME2}" ]; then
  echo ""
  echo "Cleaning ${INSTALL_DIR}/${PACKAGE_NAME2} file ..."
  echo ""
  rm -f ${PACKAGE_NAME2}
fi

# Downloading file 1
PACKAGE_FULL_URL1="${PACKAGE_URL1}/${PACKAGE_NAME1}"

echo ""
echo "Downloading file ${PACKAGE_FULL_URL1}"
echo ""
wget --no-check-certificate ${PACKAGE_FULL_URL1}

if [ "${?}" != "0" ] ; then
  echo "Error: downloading failed!"
  exit 1
fi

# Downloading file 2
PACKAGE_FULL_URL2="${PACKAGE_URL2}/${PACKAGE_NAME2}"

echo ""
echo "Downloading file ${PACKAGE_FULL_URL2}"
echo ""
wget --no-check-certificate ${PACKAGE_FULL_URL2}

if [ "${?}" != "0" ] ; then
  echo "Error: downloading failed!"
  exit 1
fi

#####################################################################
echo ""
echo "Successfully downloaded ILSVRC'12 train dataset for MXNet ..."
exit 0

#! /bin/bash

#
# Installation script for Aggregathor.
#
# See CK LICENSE for licensing details.
# See CK COPYRIGHT for copyright details.
#
# Developer(s):
# - Grigori Fursin, 2016-2018
#

# PACKAGE_DIR
# INSTALL_DIR

cd ${INSTALL_DIR}

# Clean install
if [ -d "${PACKAGE_WORK_DIR}" ]; then
  echo ""
  echo "Cleaning ${INSTALL_DIR}/${PACKAGE_WORK_DIR} directory ..."
  echo ""
  rm -rf ${PACKAGE_WORK_DIR}
fi

# Clean install
if [ -f "${PACKAGE_NAME}" ]; then
  echo ""
  echo "Cleaning ${INSTALL_DIR}/${PACKAGE_NAME} file ..."
  echo ""
  rm -f ${PACKAGE_NAME}
fi

# Downloading file
PACKAGE_FULL_URL="${PACKAGE_URL}/${PACKAGE_NAME}"

echo ""
echo "Downloading file ${PACKAGE_FULL_URL}"
echo ""
wget --no-check-certificate ${PACKAGE_FULL_URL}

if [ "${?}" != "0" ] ; then
  echo "Error: downloading failed!"
  exit 1
fi

# Unzipping file
unzip ${PACKAGE_NAME}
if [ "${?}" != "0" ] ; then
  echo "Error: unzipping failed!"
  exit 1
fi

# Removing zip
rm -f ${PACKAGE_NAME}
if [ "${?}" != "0" ] ; then
  echo "Error: removing downloaded file failed!"
  exit 1
fi

# Preparing MxNet
cd ${PACKAGE_WORK_DIR}

EXTRA_MAKE_FLAGS=""

export PKG_CONFIG_PATH=${CK_ENV_LIB_OPENCV_LIB}/pkgconfig:$PKG_CONFIG_PATH

#     -j ${CK_HOST_CPU_NUMBER_OF_PROCESSORS} \

make ${CK_MAKE_BEFORE} \
     -j ${CK_HOST_CPU_NUMBER_OF_PROCESSORS} \
     USE_OPENCV=1 \
     USE_BLAS=openblas \
     USE_CUDNN=1 \
     USE_CUDA_PATH=${CK_ENV_COMPILER_CUDA} \
     ${EXTRA_MAKE_FLAGS}

if [ "${?}" != "0" ] ; then
  echo "Error: installation failed!"
  exit 1
fi

# Check created lib
rm -rf lib64
cp -rf lib lib64

if [ ! -f "lib64/libmxnet.so" ] ; then
  echo ""
  echo "Error: Can't find lib64/libmxnet.so"
  echo ""
  exit 1
fi

######################################################################################
# Print info about possible issues
echo ""
echo "Note that you sometimes need to upgrade your pip to the latest version"
echo "to avoid well-known issues with user/system space installation:"

SUDO="sudo "
if [[ ${CK_PYTHON_PIP_BIN_FULL} == /home/* ]] ; then
  SUDO=""
fi

######################################################################################
# Check if has --system option
${CK_ENV_COMPILER_PYTHON_FILE} -m pip install --help > tmp-pip-help.tmp
if grep -q "\-\-system" tmp-pip-help.tmp ; then
 SYS=" --system"
fi
rm -f tmp-pip-help.tmp

######################################################################################
echo "Downloading and installing Python deps ..."
echo ""

EXTRA_PYTHON_SITE=${INSTALL_DIR}/lib
mkdir -p ${EXTRA_PYTHON_SITE}

${CK_ENV_COMPILER_PYTHON_FILE} -m pip install graphviz pyyaml numpy decorator opencv-python wget matplotlib jupyter -t ${EXTRA_PYTHON_SITE}  ${SYS}
if [ "${?}" != "0" ] ; then
  echo "Error: installation failed!"
  exit 1
fi

export LD_LIBRARY_PATH=$INSTALL_DIR/${PACKAGE_WORK_DIR}/lib64:$LD_LIBRARY_PATH
${CK_ENV_COMPILER_PYTHON_FILE} -m pip install python/ -t ${EXTRA_PYTHON_SITE}  ${SYS}
if [ "${?}" != "0" ] ; then
  echo "Error: installation failed!"
  exit 1
fi

exit 0

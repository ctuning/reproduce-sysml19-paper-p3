#!/bin/bash

CURDIR=$(pwd)

cd ${CK_ENV_TOOL_SYSML19_P3}

${CK_ENV_COMPILER_PYTHON_FILE} tools/launch.py \
 -n ${NUMBER_OF_NODES} \
 -H ${CURDIR}/hosts \
 "export PYTHONPATH=${PYTHONPATH}; ${CK_ENV_COMPILER_PYTHON_FILE}" \
 example/image-classification/train_imagenet.py \
 --gpus 0 \
 --network ${MODEL} \
 ${EXTRA_OPTS} \
 --batch-size ${BATCH_SIZE} \
 --image-shape ${IMAGE_SHAPE} \
 --num-epochs 1 \
 --kv-store dist_device_sync \
 --data-train ${CK_ENV_DATASET_IMAGENET_TRAIN_MXNET}/imagenet1k_train.rec \
 --data-val ${CK_ENV_DATASET_IMAGENET_TRAIN_MXNET}/imagenet1k_val.rec

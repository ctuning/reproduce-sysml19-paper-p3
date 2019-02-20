#!/bin/bash

CURDIR=$(pwd)

cd ${CK_ENV_TOOL_SYSML19_P3}

python3 tools/launch.py -n 1 -H hosts python3 example/image-classification/train_imagenet.py --gpus 0 --network resnet --num-layers 50 --batch-size 1 --image-shape 3,224,224 --num-epochs 1 --kv-store dist_device_sync --data-train /home/gfursin/CK-TOOLS/dataset-imagenet-ilsvrc2012-train-p3/install/imagenet1k_train.rec --data-val /home/gfursin/CK-TOOLS/dataset-imagenet-ilsvrc2012-train-p3/install/imagenet1k_val.rec

${CK_ENV_COMPILER_PYTHON_FILE} tools/launch.py \
 -n ${NUMBER_OF_NODES} \
 -H ${CURDIR}/hosts \
 ${CK_ENV_COMPILER_PYTHON_FILE} \
 example/image-classification/train_imagenet.py \
 --gpus 0 \
 --network ${MODEL} \
 --num-layers ${NUM_LAYERS} \
 --batch-size ${BATCH_SIZE} \
 --image-shape 3,224,224 \
 --num-epochs 1 \
 --kv-store dist_device_sync \
 --data-train ${CK_ENV_DATASET_IMAGENET_TRAIN_MXNET}/imagenet1k_train.rec \
 --data-val ${CK_ENV_DATASET_IMAGENET_TRAIN_MXNET}/imagenet1k_val.rec

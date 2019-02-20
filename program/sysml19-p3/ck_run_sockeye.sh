#!/bin/bash

CURDIR=$(pwd)

cd ${CK_ENV_TOOL_SYSML19_P3}/example/sockeye/source

${CK_ENV_COMPILER_PYTHON_FILE} ../../../tools/launch.py \
 -n ${NUMBER_OF_NODES} \
 -H ${CURDIR}/hosts \
 "export PYTHONPATH=${PYTHONPATH}; ${CK_ENV_COMPILER_PYTHON_FILE}" \
 -m sockeye.train \
 --source ../dataset/iwslt15_en-vi/train-preproc.en \
 --target ../dataset/iwslt15_en-vi/train-preproc.vi \
 --validation-source ../dataset/iwslt15_en-vi/tst2012.en \
 --validation-target ../dataset/iwslt15_en-vi/tst2012.vi \
 --source-vocab ../dataset/iwslt15_en-vi/vocab.en \
 --target-vocab ../dataset/iwslt15_en-vi/vocab.vi \
 --output ../models/sockeye_1.5-iwslt15_en-vi.sh \
 --overwrite-output \
 --encoder rnn \
 --decoder rnn \
 --num-layers 2:2 \
 --rnn-cell-type lstm \
 --rnn-num-hidden 512 \
 --rnn-encoder-reverse-input \
 --num-embed 512:512 \
 --attention-type mlp \
 --attention-num-hidden 512 \
 --batch-size ${BATCH_SIZE} \
 --bucket-width 10 \
 --metrics perplexity \
 --optimized-metric bleu \
 --checkpoint-frequency 10000000000 \
 --max-num-checkpoint-not-improved -1 \
 --weight-init uniform \
 --weight-init-scale 0.1 \
 --learning-rate-reduce-factor 1.0 \
 --monitor-bleu -1 \
 --kv-store dist_device_sync

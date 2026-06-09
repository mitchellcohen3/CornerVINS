#!/bin/bash
set -e

CONFIG_PATH=/workspace/CornerVINS/config/
CONFIG_NAME=cid.yaml
DATASET_PATH=/data/floor13_1/
RESULTS_PATH=/workspace/results/
TRAJ_FILE="${RESULTS_PATH}/test.txt"
TIME_FILE="${RESULTS_PATH}/time.txt"

mkdir -p "$RESULTS_PATH"

/workspace/CornerVINS/bin/test_cid \
    "$CONFIG_PATH" \
    "$CONFIG_NAME" \
    "$DATASET_PATH" \
    "$RESULTS_PATH" \
    "$TRAJ_FILE" \
    "$TIME_FILE"

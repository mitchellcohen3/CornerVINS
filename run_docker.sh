#!/bin/bash
set -e

DATA_PATH="/media/mitchell/T7/data/CID-SIMS"

RESULTS_PATH="$(pwd)/results"
mkdir -p "$RESULTS_PATH"

xhost +local:docker

docker run -it --net=host --gpus all \
    -e DISPLAY=$DISPLAY \
    -v /tmp/.X11-unix:/tmp/.X11-unix \
    --device /dev/dri \
    -v "$DATA_PATH":/data \
    -v "$RESULTS_PATH":/workspace/results \
    -v "$(pwd)":/workspace/CornerVINS \
    cornervins

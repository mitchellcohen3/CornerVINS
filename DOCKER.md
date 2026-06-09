# Building and Running CornerVINS with Docker

## Prerequisites
- [Docker](https://docs.docker.com/engine/install/) should be installed on your machine.
- The precompiled `lib/libCornerVINS.so` present in the repo (download from the [Google Drive link](https://drive.google.com/file/d/1DPeP46gTaTSOTJH4XNwSr_cskvurhojT/view)). This should be placed in the `lib/` directory at the root of the repo.

## 1. Build the image
After cloning the repo and placing the precompiled library, build the container image using
```bash
docker build -t cornervins .
```
This compiles all dependencies from source (Ceres, OpenCV + contrib, Pangolin), but does not build CornerVINS itself.s

## 2. Configure the dataset path

Edit `run_docker.sh` and set `DATA_PATH` to the absolute path of your dataset on the host:

```bash
DATA_PATH=/path/to/your/dataset
```

The dataset must follow this structure, following the format used in the CID-SIMS dataset:
```
<dataset>/
├── color/
│   └── <timestamp>.png
├── depth/
│   └── <timestamp>.png
├── associations.txt
├── groundtruth.txt
└── imu.txt
```

## 3. Run the container and build CornerVINS
Use the provided script to start the container, which mounts your dataset and a results directory:
```bash
./run_docker.sh
```

Once inside the container, build ConerVINS itself using

```bash
cd /workspace/CornerVINS && mkdir -p build && cd build && cmake .. && make -j$(nproc)
```
The `bin/` output is written back to your host directory, so this only needs to be done once (or after source changes).

## 5. Run CornerVINS
Inside the container:

```bash
/workspace/CornerVINS/run_cid.sh
```
Results (trajectory and timing files) are written to `/workspace/results/` inside the container, which maps back to `./results/` on the host.

# Notes
- Visualization is controlled via the is_visualize flag in `run_cid.sh.

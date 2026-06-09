FROM ubuntu:18.04

ENV DEBIAN_FRONTEND=noninteractive

# ──────────────────────────────────────────────────────────────
# Base build tools
# ──────────────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    unzip \
    pkg-config \
    && rm -rf /var/lib/apt/lists/*

# ──────────────────────────────────────────────────────────────
# Eigen3 + Boost
# ──────────────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y \
    libeigen3-dev \
    libboost-all-dev \
    && rm -rf /var/lib/apt/lists/*

# ──────────────────────────────────────────────────────────────
# PCL (no version pinned in CMakeLists — apt version is fine)
# ──────────────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y \
    libpcl-dev \
    && rm -rf /var/lib/apt/lists/*

# ──────────────────────────────────────────────────────────────
# Ceres 1.14.0 (built from source — README requires this exact version)
# Must come before OpenCV so the sfm contrib module can find it.
# ──────────────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y \
    libgoogle-glog-dev \
    libgflags-dev \
    libatlas-base-dev \
    libsuitesparse-dev \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q -O /tmp/ceres.tar.gz \
        http://ceres-solver.org/ceres-solver-1.14.0.tar.gz && \
    cd /tmp && tar xf ceres.tar.gz && \
    cd ceres-solver-1.14.0 && mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make -j4 && make install && ldconfig && \
    cd /tmp && rm -rf ceres.tar.gz ceres-solver-1.14.0

# ──────────────────────────────────────────────────────────────
# OpenCV 3.3.1 + opencv_contrib (built from source)
# opencv_contrib provides libopencv_sfm, which requires Ceres.
# Note: libjasper-dev is only available on 18.04, one reason for
# using this base image.
# ──────────────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y \
    libgtk2.0-dev \
    libavcodec-dev \
    libavformat-dev \
    libswscale-dev \
    python-dev \
    python-numpy \
    libtbb2 \
    libtbb-dev \
    libjpeg-dev \
    libpng-dev \
    libtiff-dev \
    libdc1394-22-dev \
    && rm -rf /var/lib/apt/lists/*

RUN wget -q -O /tmp/opencv.zip \
        https://github.com/opencv/opencv/archive/3.3.1.zip && \
    wget -q -O /tmp/opencv_contrib.zip \
        https://github.com/opencv/opencv_contrib/archive/3.3.1.zip && \
    cd /tmp && unzip -q opencv.zip && unzip -q opencv_contrib.zip && \
    cd opencv-3.3.1 && mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release \
          -DBUILD_EXAMPLES=OFF \
          -DBUILD_TESTS=OFF \
          -DBUILD_PERF_TESTS=OFF \
          -DWITH_JASPER=OFF \
          -DOPENCV_EXTRA_MODULES_PATH=/tmp/opencv_contrib-3.3.1/modules \
          .. && \
    make -j$(nproc) && make install && ldconfig && \
    cd /tmp && rm -rf opencv.zip opencv_contrib.zip opencv-3.3.1 opencv_contrib-3.3.1

# ──────────────────────────────────────────────────────────────
# Pangolin 0.6 (built from source)
# ──────────────────────────────────────────────────────────────
RUN apt-get update && apt-get install -y \
    libglew-dev \
    libgl1-mesa-dev \
    libgl1-mesa-glx \
    libglu1-mesa-dev \
    mesa-utils \
    && rm -rf /var/lib/apt/lists/*

RUN git clone --branch v0.6 --depth 1 \
        https://github.com/stevenlovegrove/Pangolin.git /tmp/Pangolin && \
    cd /tmp/Pangolin && mkdir build && cd build && \
    cmake -DCMAKE_BUILD_TYPE=Release .. && \
    make -j4 && make install && ldconfig && \
    rm -rf /tmp/Pangolin

WORKDIR /workspace/CornerVINS

CMD ["/bin/bash"]

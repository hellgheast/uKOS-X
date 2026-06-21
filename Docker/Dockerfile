FROM ubuntu:22.04

LABEL author="hellgheast"
LABEL name="ukosx_tools" 

ENV LANG C.UTF-8

RUN apt-get update && apt-get -y upgrade

# Setup timezone
ENV TZ Europe/Zurich
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
RUN apt-get -y install tzdata

# Setup the minimal stuff needed for cross-compilation & doxygen build
RUN apt-get -y install \
    automake \
    build-essential \
    bison flex gawk m4 texinfo \
    libtool libtool-bin \
    clang cmake \
    git curl wget \
    zsh \
    openocd \
    lcov lzip \
    ninja-build meson \
    pandoc \
    zlib1g-dev \
    libncurses-dev \
    libusb-1.0-0-dev libusb-dev \
    libpcre3 libpcre3-dev \
    libgl1-mesa-dev \
    libhidapi-dev \
    libgtk2.0-dev \
    libudev-dev \
    libjaylink-dev \
    intltool


# Install yq (snap unavailable in Docker — download binary directly)
RUN wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/local/bin/yq && chmod +x /usr/local/bin/yq

#RUN apt-get -y install build-essential git rsync graphviz flex bison zlib1g-dev texinfo autoconf automake libtool cmake m4 pkg-config libudev-dev wget libgmp-dev lcov lzip ninja-build meson

# zsh by default
RUN chsh -s /usr/bin/zsh || true
 

# Python shenanigans for working correctly
RUN apt-get -y install python3 python3-pip python-is-python3
# Make the "python" executable available and redirect to "python3"
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 10
# Install some packages
RUN pip install --upgrade pip
RUN pip install pyserial pytest paho-mqtt numpy pytest-rerunfailures pyocd numpy matplotlib pillow PyYAML

RUN mkdir -p /opt/uKOS /opt/uKOS/local/bin

SHELL ["/bin/zsh", "-c"]

WORKDIR /home

# Take the 15.2 ARM toolchain
ENV PATH_TOOLS_ROOT=/opt/uKOS
# The Find part creates a gcc symbolic folder based on the last version of GCC available on arm website
RUN mkdir -p /opt/uKOS/cross && cd /opt/uKOS/cross && wget https://developer.arm.com/-/media/Files/downloads/gnu/15.2.rel1/binrel/arm-gnu-toolchain-15.2.rel1-x86_64-arm-none-eabi.tar.xz && tar -xf *.xz && find . -maxdepth 1 -type d -name "*arm-none-eabi*"  -exec ln -s {} gcc_arm \; && rm *.xz 

# Get RISC-V toolchain from Xpack
RUN cd /opt/uKOS/cross && wget https://github.com/xpack-dev-tools/riscv-none-elf-gcc-xpack/releases/download/v15.2.0-1/xpack-riscv-none-elf-gcc-15.2.0-1-linux-x64.tar.gz && tar -xzf *.tar.gz && find . -maxdepth 1 -type d -name "*riscv-none-elf*" -exec ln -s {} gcc_riscv \; && rm *.tar.gz
# Create riscv64-unknown-elf-* aliases expected by the build scripts (e.g. riscv64-unknown-elf-gcc)
RUN for f in /opt/uKOS/cross/gcc_riscv/bin/riscv-none-elf-*; do ln -s "$f" "/opt/uKOS/cross/gcc_riscv/bin/riscv64-unknown-elf-${f##*/riscv-none-elf-}"; done


COPY start.sh /home/start.sh
CMD source /home/start.sh && zsh

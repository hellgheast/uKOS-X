# Setup the environnement for the compilation
PATH_TOOLS_ROOT=/opt/uKOS  # /opt/uKOS in this example

export PATH_TOOLS_GCC=${PATH_TOOLS_ROOT}

# Settings for arm toolchain

export PATH_GCC_ARM=${PATH_TOOLS_ROOT}/cross/gcc_arm
export PATH_GCC_RVXX=${PATH_TOOLS_ROOT}/cross/gcc_riscv
export PATH_LLVM_CORTEXM=${PATH_TOOLS_ROOT}/cross/llvm

PATH=${PATH}:${PATH_GCC_ARM}/bin:${PATH_GCC_RVXX}/bin

export PATH

echo "uKOS-X Docker setup done"
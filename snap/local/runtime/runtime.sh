#!/bin/bash
set -euo pipefail

mlx_prepare_runtime() {
    export HOME="$1"
    umask 077
    mkdir -p "$HOME/.mlx-serve/models" "$HOME/tmp"
    export TMPDIR="$HOME/tmp"

    export CUDA_HOME="$SNAP/usr/local/cuda-13.4"
    export CUDA_PATH="$CUDA_HOME"
    local runtime_libraries="$SNAP/lib/mlx/lib:$SNAP/lib/llama/lib:$SNAP/lib/ds4-linux"
    runtime_libraries+=":$CUDA_HOME/lib64:$CUDA_HOME/targets/x86_64-linux/lib"
    runtime_libraries+=":$CUDA_HOME/targets/aarch64-linux/lib:$CUDA_HOME/targets/sbsa-linux/lib"
    runtime_libraries+=":$SNAP/usr/lib/x86_64-linux-gnu:$SNAP/usr/lib/aarch64-linux-gnu"
    runtime_libraries+=":$SNAP/usr/lib/x86_64-linux-gnu/openblas-pthread:$SNAP/usr/lib/aarch64-linux-gnu/openblas-pthread"
    runtime_libraries+=":$SNAP/lib/x86_64-linux-gnu:$SNAP/lib/aarch64-linux-gnu"
    export LD_LIBRARY_PATH="$runtime_libraries:/var/lib/snapd/lib/gl${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
    export CURL_CA_BUNDLE="$SNAP/etc/ssl/certs/ca-certificates.crt"
    export SSL_CERT_FILE="$CURL_CA_BUNDLE"

    # MLX keeps a build-specific kernel cache below TMPDIR.
}

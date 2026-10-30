#!/bin/bash
set -euo pipefail

source "$SNAP/libexec/mlx-serve/config.sh"
mlx_load_daemon_config
mlx_validate_daemon_config
if [[ "$MLX_DAEMON_ENABLED" != true ]]; then
    echo "The daemon is disabled; enable it with snap set $SNAP_INSTANCE_NAME daemon.enabled=true."
    exit 0
fi

source "$SNAP/libexec/mlx-serve/runtime.sh"
mlx_prepare_runtime "$SNAP_COMMON"
daemon_args=(--serve --host "$MLX_DAEMON_HOST" --port "$MLX_DAEMON_PORT"
    --model-dir "$HOME/.mlx-serve/models" --log-file off)
if [[ -n "$MLX_DAEMON_API_KEY" ]]; then
    export MLX_SERVE_SNAP_API_KEY="$MLX_DAEMON_API_KEY"
    daemon_args+=(--api-key-env MLX_SERVE_SNAP_API_KEY --api-key-strict)
fi
exec "$SNAP/zig-out/bin/mlx-serve" "${daemon_args[@]}"

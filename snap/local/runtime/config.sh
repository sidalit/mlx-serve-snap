#!/bin/bash
set -euo pipefail

mlx_load_daemon_config() {
    MLX_DAEMON_ENABLED="$(snapctl get daemon.enabled)"
    MLX_DAEMON_HOST="$(snapctl get daemon.host)"
    MLX_DAEMON_PORT="$(snapctl get daemon.port)"
    MLX_DAEMON_API_KEY="$(snapctl get daemon.api-key)"
    MLX_DAEMON_ENABLED="${MLX_DAEMON_ENABLED:-false}"
    MLX_DAEMON_HOST="${MLX_DAEMON_HOST:-127.0.0.1}"
    MLX_DAEMON_PORT="${MLX_DAEMON_PORT:-11234}"
}

mlx_validate_daemon_config() {
    case "$MLX_DAEMON_ENABLED" in
        true|false) ;;
        *) echo "daemon.enabled must be true or false" >&2; return 1 ;;
    esac
    case "$MLX_DAEMON_HOST" in
        127.0.0.1|0.0.0.0) ;;
        *) echo "daemon.host must be 127.0.0.1 or 0.0.0.0" >&2; return 1 ;;
    esac
    if ! [[ "$MLX_DAEMON_PORT" =~ ^[0-9]{1,5}$ ]] ||
        ! ((10#$MLX_DAEMON_PORT >= 1 && 10#$MLX_DAEMON_PORT <= 65535)); then
        echo "daemon.port must be an integer between 1 and 65535" >&2
        return 1
    fi
    if [[ "$MLX_DAEMON_API_KEY" =~ [[:space:]] ]]; then
        echo "daemon.api-key must not contain whitespace" >&2
        return 1
    fi
    if [[ "$MLX_DAEMON_HOST" == 0.0.0.0 && -z "$MLX_DAEMON_API_KEY" ]]; then
        echo "daemon.api-key is required when daemon.host is 0.0.0.0" >&2
        return 1
    fi
}

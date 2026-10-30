#!/bin/bash
set -euo pipefail

if [[ "${1:-}" == launch ]]; then
    echo "The strict snap cannot launch host-installed coding agents. Start the server and point your agent at its HTTP API." >&2
    exit 64
fi

for argument in "$@"; do
    case "$argument" in
        --lan-share|--lan-share=*|--lan-discover|--lan-discover=*|--lan-name|--lan-name=*)
            echo "LAN discovery and advertisement are unavailable in this snap. Connect clients directly to the server's HTTP address." >&2
            exit 64
            ;;
    esac
done

source "$SNAP/libexec/mlx-serve/runtime.sh"
mlx_prepare_runtime "$SNAP_USER_COMMON"
exec "$SNAP/zig-out/bin/mlx-serve" "$@"

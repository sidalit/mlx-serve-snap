<div align="center">

<img src="snap/gui/mlx-serve.png" alt="MLX-Serve logo" width="128" />

# MLX-Serve

**Local AI models with OpenAI, Anthropic and Ollama-compatible APIs**

[![mlx-serve](https://snapcraft.io/mlx-serve/badge.svg)](https://snapcraft.io/mlx-serve)
[![Base: core24](https://img.shields.io/badge/Base-core24-2C8C3C?logo=canonical&logoColor=white)](https://snapcraft.io/core24)
![Confinement: strict](https://img.shields.io/badge/Confinement-strict-2C8C3C)
[![Maintainer: sidaliteir](https://img.shields.io/badge/Maintainer-sidaliteir-2C8C3C?logo=snapcraft&logoColor=white)](https://snapcraft.io/publisher/sidaliteir)
![Architectures: amd64 and arm64](https://img.shields.io/badge/Architectures-amd64%20%7C%20arm64-2C8C3C?logo=linux&logoColor=white)

[Getting Started](#getting-started) · [Configure](#configure) · [Limitations](#limitations) · [Build](#build) · [Support](#support) · [License](#license)

Unofficial snap packaging for [MLX-Serve](https://github.com/ddalcu/mlx-serve), a local inference server and model-management CLI for supported NVIDIA systems.

</div>

---

## Getting Started

<a href="https://snapcraft.io/mlx-serve"><img alt="Get it from the Snap Store" src="https://snapcraft.io/en/dark/install.svg" width="180"></a>

```bash
sudo snap install mlx-serve
mlx-serve run gemma4 --host 127.0.0.1
```

A compatible NVIDIA GPU and driver 580 or newer are required. Models download when requested and persist under `~/snap/mlx-serve/common`.

## Configure

The foreground CLI accepts [upstream arguments](https://github.com/ddalcu/mlx-serve/blob/main/docs/cli.md). The optional background service uses these snap settings:

| Option | Values | Default |
|---|---|---|
| `daemon.enabled` | `true`, `false` | `false` |
| `daemon.host` | `127.0.0.1`, `0.0.0.0` | `127.0.0.1` |
| `daemon.port` | `1`–`65535` | `11234` |
| `daemon.api-key` | API key; unset to disable authentication | Unset |

```bash
sudo snap set mlx-serve daemon.enabled=true
```

The service uses its own model store under `/var/snap/mlx-serve/common`. Download a model into that store through its API:

```bash
curl http://127.0.0.1:11234/api/pull \
  -H 'Content-Type: application/json' \
  -d '{"model":"gemma4","stream":false}'
```

Set `daemon.api-key` before exposing the service with `daemon.host=0.0.0.0`; authenticated requests need an `Authorization: Bearer <key>` header. Service settings do not change separate foreground CLI sessions.

```bash
sudo snap connect mlx-serve:removable-media  # optional: models on /media, /mnt
```

## Limitations

- Linux NVIDIA inference only; no macOS desktop application, Apple-only models or general CPU/AMD/Intel GPU backend.
- amd64 requires an x86-64-v3 CPU. ARM64 requires supported NVIDIA hardware, not a generic ARM board.
- Launch coding agents outside the snap and connect them to its API. Host-agent launching and LAN discovery are unavailable.

## Build

```bash
git clone https://github.com/sidalit/mlx-serve-snap.git
cd mlx-serve-snap
sudo snap install snapcraft --classic
snapcraft pack
```

## Support

- **Installation or snap issues:** [open a packaging issue](https://github.com/sidalit/mlx-serve-snap/issues).
- **Application bugs:** [report them upstream](https://github.com/ddalcu/mlx-serve/issues).

## License

Snap packaging: [MIT](https://github.com/sidalit/mlx-serve-snap/blob/main/LICENSE).

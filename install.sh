#!/usr/bin/env bash
# insta-assist installer
# Usage:
#   curl -fsSL https://example.com/install.sh | bash
# or download and run: PREFIX=/usr/local sudo bash install.sh

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PREFIX="${PREFIX:-/usr/local}"
BINDIR="${BINDIR:-${PREFIX}/bin}"
TARGET="${BINDIR}/inst"

echo "==> Building inst (Go required)..."
BUILD_DIR="$(mktemp -d)"
cleanup() { rm -rf "$BUILD_DIR"; }
trap cleanup EXIT

if ! command -v go >/dev/null 2>&1; then
  echo "Go toolchain not found. Please install Go first." >&2
  exit 1
fi

GO_INSTALL_DIR="${BUILD_DIR}/bin"
GOBIN="${GO_INSTALL_DIR}" go install "${REPO_ROOT}/cmd/inst"

BIN_SRC="${GO_INSTALL_DIR}/inst"
if [ ! -f "$BIN_SRC" ]; then
  echo "Build failed: binary not found at ${BIN_SRC}" >&2
  exit 1
fi

echo "==> Installing to ${TARGET}"
mkdir -p "${BINDIR}"
cp "${BIN_SRC}" "${TARGET}"

echo "✅ Installed inst to ${TARGET}"
echo "Add ${BINDIR} to your PATH if it's not already there."

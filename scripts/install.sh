#!/usr/bin/env bash
set -euo pipefail

THEME_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TARGET_DIR="/usr/share/sddm/themes/NightframeSDDM"
PRESET=""
DRY_RUN=0

usage() {
    cat <<'EOF'
Usage: ./scripts/install.sh [--target <dir>] [--preset <name>] [--dry-run]

Examples:
    ./scripts/install.sh --preset default
    ./scripts/install.sh --preset night
    ./scripts/install.sh --preset rain
    ./scripts/install.sh --preset pixel
  ./scripts/install.sh --target /usr/share/sddm/themes/NightframeSDDM
EOF
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --target)
            TARGET_DIR="${2:-}"
            shift 2
            ;;
        --preset)
            PRESET="${2:-}"
            shift 2
            ;;
        --dry-run)
            DRY_RUN=1
            shift
            ;;
        -h|--help)
            usage
            exit 0
            ;;
        *)
            echo "Unknown argument: $1" >&2
            usage >&2
            exit 1
            ;;
    esac
done

if [[ -n "${PRESET}" ]]; then
    PRESET_FILE="${THEME_DIR}/presets/${PRESET}.conf"
    if [[ ! -f "${PRESET_FILE}" ]]; then
        echo "Preset not found: ${PRESET}" >&2
        exit 1
    fi
fi

STAGING_DIR="$(mktemp -d)"
cleanup() {
    rm -rf "${STAGING_DIR}"
}
trap cleanup EXIT

cp -a "${THEME_DIR}/." "${STAGING_DIR}/"
rm -rf "${STAGING_DIR}/.git" "${STAGING_DIR}/.gitignore"

if [[ -n "${PRESET}" ]]; then
    cp "${THEME_DIR}/presets/${PRESET}.conf" "${STAGING_DIR}/theme.conf"
fi

if [[ "${DRY_RUN}" -eq 1 ]]; then
    echo "[dry-run] Would install NightframeSDDM to: ${TARGET_DIR}"
    echo "[dry-run] Preset: ${PRESET:-theme.conf default}"
    exit 0
fi

INSTALL_CMD=""
if [[ ! -w "$(dirname "${TARGET_DIR}")" ]]; then
    if command -v sudo >/dev/null 2>&1; then
        INSTALL_CMD="sudo"
    else
        echo "No write permission for ${TARGET_DIR} and sudo is unavailable." >&2
        exit 1
    fi
fi

${INSTALL_CMD} mkdir -p "${TARGET_DIR}"
${INSTALL_CMD} cp -a "${STAGING_DIR}/." "${TARGET_DIR}/"

echo "Installed NightframeSDDM to: ${TARGET_DIR}"
if [[ -n "${PRESET}" ]]; then
    echo "Applied preset: ${PRESET}"
fi

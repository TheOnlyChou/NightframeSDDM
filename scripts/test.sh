#!/usr/bin/env bash
set -euo pipefail

THEME_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
PRESET=""
DEBUG_AUTH="${NIGHTFRAME_DEBUG_AUTH:-0}"

usage() {
    cat <<'EOF'
Usage: ./scripts/test.sh [--preset <name>] [--list-presets] [--debug-auth]

Examples:
  ./scripts/test.sh
    ./scripts/test.sh --preset default
    ./scripts/test.sh --preset pixel
    ./scripts/test.sh --preset default --debug-auth
EOF
}

config_value() {
        local key="$1"
        local file="$2"
        grep -E "^${key}=" "$file" | head -n1 | cut -d'=' -f2-
}

while [[ $# -gt 0 ]]; do
    case "$1" in
        --preset)
            PRESET="${2:-}"
            shift 2
            ;;
        --list-presets)
            if [[ -d "${THEME_DIR}/presets" ]]; then
                find "${THEME_DIR}/presets" -maxdepth 1 -type f -name '*.conf' -printf '%f\n' | sed 's/\.conf$//' | sort
            fi
            exit 0
            ;;
        --debug-auth)
            DEBUG_AUTH="1"
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

required_files=(
    "${THEME_DIR}/Main.qml"
    "${THEME_DIR}/metadata.desktop"
    "${THEME_DIR}/theme.conf"
)

for f in "${required_files[@]}"; do
    if [[ ! -f "${f}" ]]; then
        echo "Missing required theme file: ${f}" >&2
        exit 1
    fi
done

if [[ ! -f "${THEME_DIR}/assets/backgrounds/default.jpg" ]]; then
    echo "Warning: assets/backgrounds/default.jpg not found. Gradient fallback will be used." >&2
fi

if [[ ! -f "${THEME_DIR}/assets/fonts/JetBrainsMono-Regular.ttf" ]]; then
    echo "Warning: custom clock font not found. Monospace fallback will be used." >&2
fi

if command -v sddm-greeter-qt6 >/dev/null 2>&1; then
    GREETER_BIN="sddm-greeter-qt6"
elif command -v sddm-greeter >/dev/null 2>&1; then
    GREETER_BIN="sddm-greeter"
else
    echo "Could not find sddm-greeter-qt6 or sddm-greeter in PATH." >&2
    exit 1
fi

tmp_theme_dir="$(mktemp -d)"
cp -a "${THEME_DIR}/." "${tmp_theme_dir}/"
cleanup() {
    rm -rf "${tmp_theme_dir}"
}
trap cleanup EXIT

if [[ -n "${PRESET}" ]]; then
    preset_file="${THEME_DIR}/presets/${PRESET}.conf"
    if [[ ! -f "${preset_file}" ]]; then
        echo "Preset not found: ${PRESET}" >&2
        exit 1
    fi
    cp "${preset_file}" "${tmp_theme_dir}/theme.conf"
fi

if [[ "${DEBUG_AUTH}" == "1" ]]; then
    if grep -qE '^DebugAuthFlow=' "${tmp_theme_dir}/theme.conf"; then
        sed -i 's/^DebugAuthFlow=.*/DebugAuthFlow=true/' "${tmp_theme_dir}/theme.conf"
    else
        printf '\nDebugAuthFlow=true\n' >> "${tmp_theme_dir}/theme.conf"
    fi
fi

resolved_mode="$(config_value "BackgroundMode" "${tmp_theme_dir}/theme.conf" | tr '[:upper:]' '[:lower:]')"
resolved_use_video="$(config_value "UseVideo" "${tmp_theme_dir}/theme.conf" | tr '[:upper:]' '[:lower:]')"
resolved_mode="${resolved_mode:-image}"
video_enabled="false"
if [[ "${resolved_mode}" == "video" || "${resolved_use_video}" == "true" ]]; then
    video_enabled="true"
fi

if [[ "${video_enabled}" == "true" ]]; then
    resolved_video_path="$(config_value "BackgroundVideo" "${tmp_theme_dir}/theme.conf")"
    if [[ -n "${resolved_video_path}" && ! -f "${tmp_theme_dir}/${resolved_video_path}" ]]; then
        echo "Warning: configured preset video not found (${resolved_video_path}). Component-level fallback to image will be used." >&2
    fi
fi

# Prefer software decoding for local preview to avoid noisy hardware backend failures.
export QT_FFMPEG_DECODING_HW_DEVICE_TYPES=""

if [[ "${NIGHTFRAME_QUIET_TEST:-0}" == "1" ]]; then
    export QT_LOGGING_RULES="qt.multimedia.ffmpeg.warning=false;qt.multimedia.ffmpeg.hwaccel.warning=false"
fi

active_preset="$(grep -E '^Preset=' "${tmp_theme_dir}/theme.conf" | head -n1 | cut -d'=' -f2 || true)"
active_preset="${active_preset:-default}"
effective_mode="image"
if [[ "${video_enabled}" == "true" ]]; then
    effective_mode="video"
fi
echo "Running theme preview from: ${THEME_DIR} (mode=${effective_mode}, preset=${active_preset})"
if [[ "${DEBUG_AUTH}" == "1" ]]; then
    echo "Auth debug overlay: enabled"
fi
echo "Note: sddm-greeter --test-mode previews QML only and does not execute real PAM password authentication."
"${GREETER_BIN}" --test-mode --theme "${tmp_theme_dir}"

#!/usr/bin/env bash
set -euo pipefail

THEME_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
MODE="${1:-image}"

if [[ "${MODE}" != "image" && "${MODE}" != "video" ]]; then
    echo "Usage: $0 [image|video]" >&2
    exit 1
fi

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

if [[ "${MODE}" == "video" && ! -f "${THEME_DIR}/assets/video/nightframe.mp4" ]]; then
    echo "Warning: assets/video/nightframe.mp4 not found. Component-level fallback to image will be used." >&2
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

if [[ "${MODE}" == "video" ]]; then
    sed -i 's/^BackgroundMode=.*/BackgroundMode=video/' "${tmp_theme_dir}/theme.conf"
    sed -i 's/^UseVideo=.*/UseVideo=true/' "${tmp_theme_dir}/theme.conf"
else
    sed -i 's/^BackgroundMode=.*/BackgroundMode=image/' "${tmp_theme_dir}/theme.conf"
    sed -i 's/^UseVideo=.*/UseVideo=false/' "${tmp_theme_dir}/theme.conf"
fi

# Prefer software decoding for local preview to avoid noisy hardware backend failures.
export QT_FFMPEG_DECODING_HW_DEVICE_TYPES=""

if [[ "${NIGHTFRAME_QUIET_TEST:-0}" == "1" ]]; then
    export QT_LOGGING_RULES="qt.multimedia.ffmpeg.warning=false;qt.multimedia.ffmpeg.hwaccel.warning=false"
fi

echo "Running theme preview from: ${THEME_DIR} (mode=${MODE})"
"${GREETER_BIN}" --test-mode --theme "${tmp_theme_dir}"

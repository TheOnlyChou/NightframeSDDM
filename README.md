# NightframeSDDM

NightframeSDDM is a custom dark cinematic SDDM theme built with Qt6/QML.

It keeps wallpaper visibility high, uses a minimal login surface, and includes SVG power controls with optional video background support.

## Features

- Stable image-first mode (default)
- Optional video background mode
- Automatic fallback to image when video fails
- Modular QML architecture for maintainability
- Preset system via `presets/*.conf`
- SVG icon power controls (sleep, reboot, shutdown)

## Current Style

![Current style](image.png)

## Project Tree

~~~text
NightframeSDDM/
├── assets/
│   ├── backgrounds/
│   ├── fonts/
│   ├── svg/
│   └── video/
├── components/
│   ├── Auth/
│   ├── Background/
│   ├── Common/
│   ├── Power/
│   ├── Session/
│   └── Widgets/
├── docs/
│   ├── customization.md
│   └── structure.md
├── presets/
│   ├── default.conf
│   ├── night.conf
│   ├── pixel.conf
│   └── rain.conf
├── scripts/
│   ├── install.sh
│   └── test.sh
├── Main.qml
├── metadata.desktop
├── qmldir
├── README.md
└── theme.conf
~~~

## Dependencies

- SDDM with Qt6 greeter (`sddm-greeter-qt6` preferred)
- Qt6 QML runtime
- Qt Multimedia (only required for optional video mode)

## Local Testing

Image mode (default):

~~~bash
./scripts/test.sh
./scripts/test.sh image
~~~

Video mode (optional):

~~~bash
./scripts/test.sh video
~~~

Test with a preset:

~~~bash
./scripts/test.sh image --preset night
./scripts/test.sh video --preset rain
~~~

List available presets:

~~~bash
./scripts/test.sh --list-presets
~~~

Reduce local multimedia warning noise:

~~~bash
NIGHTFRAME_QUIET_TEST=1 ./scripts/test.sh video
~~~

## Install Workflow

Install to the standard SDDM location:

~~~bash
./scripts/install.sh
~~~

Install with preset:

~~~bash
./scripts/install.sh --preset night
~~~

Custom target path:

~~~bash
./scripts/install.sh --target /usr/share/sddm/themes/NightframeSDDM
~~~

## Image vs Optional Video

- Image mode is the safe default.
- Video mode is opt-in.
- If video decode/backend/media fails, the UI remains usable and falls back to image rendering.

## Configuration and Presets

- `theme.conf` is the active runtime config.
- `Preset=<name>` indicates the intended style preset.
- `presets/*.conf` are complete config variants that can be applied via scripts.

See:

- `docs/structure.md`
- `docs/customization.md`

## Notes on Multimedia Warnings

Warnings about FFmpeg, VAAPI, VDPAU, Bluez, or device sample formats in test mode are usually environment/runtime warnings, not necessarily theme logic errors.
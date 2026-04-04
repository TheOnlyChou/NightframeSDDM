# NightframeSDDM

NightframeSDDM is a custom cinematic dark SDDM theme built with Qt6/QML.

It focuses on anime-night / cyber-night wallpaper aesthetics with a readable, minimal login UI and optional SVG power controls.

## Current Features

- Image-first background mode (safe default)
- Optional video background mode
- Automatic fallback to image background if video fails
- Subtle dark overlay for readability
- Modular QML component structure
- SVG power buttons (sleep, reboot, shutdown)

## Current style

![Current style](image.png)

## Project Structure

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
├── Main.qml
├── metadata.desktop
├── qmldir
├── scripts/
│   └── test.sh
└── theme.conf
~~~

## Dependencies

- SDDM with Qt6 greeter (preferred: sddm-greeter-qt6)
- Qt6 QML modules
- Qt Multimedia (for optional video mode)

## Local Testing

From the project root:

~~~bash
./scripts/test.sh
~~~

Image mode (default):

~~~bash
./scripts/test.sh image
~~~

Video mode (optional):

~~~bash
./scripts/test.sh video
~~~

Optional quieter logs:

~~~bash
NIGHTFRAME_QUIET_TEST=1 ./scripts/test.sh video
~~~

## Image vs Video Mode

- Default behavior uses image mode for stability.
- Video mode is opt-in and treated as a secondary feature.
- If video playback fails (codec/backend/hardware acceleration issues), the theme falls back to image background without breaking UI layout.

## Installation Example

Install under SDDM themes path:

~~~bash
sudo cp -r NightframeSDDM /usr/share/sddm/themes/my-theme
~~~

Then select the theme in SDDM config.

## Asset Expectations

- Background image path is configured in theme.conf.
- Optional video file should be placed in assets/video/.
- SVG power icons are in assets/svg/.
- Optional custom fonts are in assets/fonts/.

## Status

Work in progress.

This project is actively refined for stability and visuals. Some multimedia warnings can come from the local FFmpeg/hardware acceleration environment during test mode rather than from the theme logic itself.
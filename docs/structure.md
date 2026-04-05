# NightframeSDDM Structure

NightframeSDDM keeps a modular Qt6/QML architecture focused on maintainable components.

## Root

- Main.qml: top-level composition and runtime wiring
- theme.conf: active runtime configuration
- metadata.desktop: SDDM metadata
- qmldir: QML module entry
- README.md: user-facing overview

## Components

- components/Background: image/video backgrounds and overlay
- components/Auth: login panel, user, password, button
- components/Widgets: clock/date/message helpers
- components/Session: session selector UI
- components/Power: power action buttons (SVG icon based)
- components/Common: shared color/metrics/fonts definitions

## Assets

- assets/backgrounds: wallpaper images
- assets/video: optional background video
- assets/fonts: optional custom fonts
- assets/svg: power icons

## Presets

- presets/default.conf
- presets/night.conf
- presets/pixel.conf
- presets/rain.conf

Preset files are complete theme.conf-style configs that can be applied in local testing or installation scripts.

## Scripts

- scripts/test.sh: local preview runner with mode/preset options
- scripts/install.sh: installs theme into SDDM themes directory with optional preset

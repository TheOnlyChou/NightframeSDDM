# NightframeSDDM Customization

NightframeSDDM supports two customization paths:

1. Edit theme.conf directly.
2. Start from a preset in presets/*.conf and apply it.

## Core Keys

- Preset: logical preset name (default, night, pixel, rain)
- BackgroundMode: image or video
- UseVideo: true or false
- BackgroundImage: image path relative to theme root
- BackgroundVideo: video path relative to theme root
- UiFont: UI font file path
- ClockFont: clock font file path
- AccentColor: hex accent color
- SecondaryAccentColor: secondary accent used by stylized controls
- OverlayStrength: 0.0 to 0.8 (recommended 0.36 to 0.60)
- OverlayTint: atmospheric overlay tint color
- PanelTint: panel glass tint color
- PanelOpacity: login + control surface opacity scalar
- PanelRadius: corner radius for key surfaces
- ControlDensity: scales compactness across login and bottom controls
- ClockScale: scales clock typography per preset
- TitleOpacity: main login title opacity
- SubtitleOpacity: subtitle/date opacity
- BottomControlsOpacity: opacity of session/power dock
- PanelHorizontalOffset: horizontal login panel offset
- PanelVerticalOffset: vertical login panel offset
- SessionStyle: balanced, minimal, soft, pixel
- TransitionProfile: default, night, rain, pixel
- ControlSpacing: spacing for control groups and panel internals
- PanelBorderStrength: border emphasis for panel/control surfaces
- Clock24h: true or false

## Preset Workflow

Test with preset without modifying repository config:

```bash
./scripts/test.sh --preset default
./scripts/test.sh --preset night
./scripts/test.sh --preset rain
./scripts/test.sh --preset pixel
```

Install with preset:

```bash
./scripts/install.sh --preset default
./scripts/install.sh --preset night
./scripts/install.sh --preset rain
./scripts/install.sh --preset pixel
```

## V4 Preset Intent

- `default`: neutral baseline for readability and wallpaper visibility
- `night`: premium, sharper, darker, more restrained
- `rain`: softer and rounder with diffuse contrast
- `pixel`: most stylized preset, compact and squarer with optional video-first mood

## Video Notes

Video mode is optional and never required for layout correctness.
If video playback fails, NightframeSDDM falls back to image mode in runtime.

## Session Selector Runtime Behavior

- In installed SDDM runtime, session entries are read only from the real `sessionModel`.
- Demo entries are not injected during normal installed runtime.
- Demo fallback sessions are used only in explicit greeter test mode (for local preview).
- Login uses the selected real session value exposed by the session selector, keeping UI selection and launched desktop session synchronized.

## Dependency Notes

Some FFmpeg or hardware decode warnings in test mode are environment-specific and do not necessarily indicate a theme bug.

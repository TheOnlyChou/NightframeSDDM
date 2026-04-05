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
- OverlayStrength: 0.0 to 0.8 (recommended 0.40 to 0.55)
- AccentColor: hex accent color
- PanelOpacity: login + control surface opacity scalar
- PanelRadius: corner radius for key surfaces
- ControlDensity: scales compactness for bottom-right controls
- Clock24h: true or false
- PixelFont: optional font path

## Preset Workflow

Test with preset without modifying repository config:

```bash
./scripts/test.sh image --preset night
./scripts/test.sh video --preset rain
```

Install with preset:

```bash
./scripts/install.sh --preset rain
```

## Video Notes

Video mode is optional and never required for layout correctness.
If video playback fails, NightframeSDDM falls back to image mode in runtime.

## Dependency Notes

Some FFmpeg or hardware decode warnings in test mode are environment-specific and do not necessarily indicate a theme bug.

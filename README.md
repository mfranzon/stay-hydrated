# Stay hydrated timer

A timer for the terminal, designed to keep you hydrated and productive with a refreshing water-themed vibe. Catch waves with sessions like *Splash Session* (25 min), *Tidal Wave* (50 min), or *Aqua Marathon* (90 min), and chill with Hydration Breaks.

Choose from:
- `--splash-session`: 25-minute work session.
- `--tidal-wave`: 50-minute work session.
- `--aqua-marathon`: 90-minute work session.

Customizable `--break` duration (default: 5 min), `-c` duration.

## Sound Notification
Plays a wave crash sound at session end, with a fallback beep if aplay or the sound file is missing.

## Waves Caught
Tracks completed work sessions.

Installable Package: Available as a .deb for Debian/Ubuntu.

`dpkg -i stayhydrated-0.1.deb`

## Usage
`watimer --tidal-wave -b 10`

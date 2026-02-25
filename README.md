# StatusVault

StatusVault is an Android-focused Flutter starter that detects WhatsApp statuses,
saves the media, and organizes everything behind folders and a private vault. It
ships with a provider-backed state layer, clean grid-based feeds, vault safeguards,
and lightweight settings + pro feature flows.

## Features

- Status detection grid with quick save/vault shortcuts
- Folder list with saved status previews and action menus
- Private vault guarded by PIN/biometric toggle simulation
- Pro feature controls for auto-download, custom folders, and expiry alerts
- Simple link download dialog and settings surface

## Getting started

1. Install Flutter and ensure `flutter doctor` is clean.
2. Fetch packages with `flutter pub get`.
3. Run on Android with `flutter run`.

The app is structured around `StatusProvider`, `StatusVaultHome`, and themed
widgets under `lib/src/`. Replace mock data with real storage watchers, a Hive/
SQLite store, and any native helpers you need for file observers or biometrics.

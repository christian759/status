# WhatsApp Status Saver

This repo now hosts a single-screen experience for WhatsApp status saving. The
app watches the WhatsApp cache, lists detected images and videos, and gives each
item a clear "Save" action with an optional vault toggle—no feed or extra tabs.

## Key behaviors

- List of detected statuses with one-tap save and vault toggles.
- Sync button stub for manual refresh of detected items.
- Provider-based state so you can plug in real file observers and persistence.

## Getting started

1. Install Flutter and ensure `flutter doctor` is clean.
2. Fetch packages with `flutter pub get`.
3. Launch on Android with `flutter run`.

Replace the seeded data in `StatusProvider` with actual file-watching logic
plus persistent storage (Hive/SQLite) as needed.

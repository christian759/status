/// Placeholder service that would wrap native platform code to observe
/// WhatsApp status folders. In a production build this could use a
/// FileObserver on Android, or a background task that polls the status path.
class StatusWatcher {
  const StatusWatcher();

  /// Start watching the expected WhatsApp status directory.
  void startWatching() {}

  /// Stop watching when the app is disposed.
  void stopWatching() {}
}

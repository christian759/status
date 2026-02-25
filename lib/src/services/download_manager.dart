/// Stub download manager that would coordinate HTTP downloads for links shared
/// from Instagram, X, TikTok, or WhatsApp. This would integrate with a
/// background downloader or platform channel to save bytes to local storage.
class DownloadManager {
  const DownloadManager();

  Future<void> downloadFromLink(String link) async {
    // TODO: integrate with actual download logic and media permissions.
  }
}

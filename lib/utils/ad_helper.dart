import 'dart:io';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:flutter/foundation.dart';

class AdHelper {
  static InterstitialAd? _interstitialAd;
  static bool _isInterstitialAdReady = false;

  static String get interstitialAdUnitId {
    if (Platform.isAndroid) {
      // Test Ad Unit ID for Android Interstitial
      return 'ca-app-pub-3940256099942544/1033173712';
    } else if (Platform.isIOS) {
      // Test Ad Unit ID for iOS Interstitial
      return 'ca-app-pub-3940256099942544/4411468910';
    } else {
      throw UnsupportedError('Unsupported platform');
    }
  }

  static void initAds() {
    MobileAds.instance.initialize();
  }

  static void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          _isInterstitialAdReady = true;
          
          _interstitialAd?.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _isInterstitialAdReady = false;
              // Reload ad for next time
              loadInterstitialAd();
            },
            onAdFailedToShowFullScreenContent: (ad, error) {
              debugPrint('Failed to show interstitial ad: $error');
              ad.dispose();
              _isInterstitialAdReady = false;
              loadInterstitialAd();
            },
          );
        },
        onAdFailedToLoad: (err) {
          debugPrint('Failed to load an interstitial ad: ${err.message}');
          _isInterstitialAdReady = false;
        },
      ),
    );
  }

  static void showInterstitialAd({required Function onAdClosed}) {
    final ad = _interstitialAd;
    if (_isInterstitialAdReady && ad != null) {
      // Temporarily override the callback to trigger our specific logic when the user closes this specific ad
      ad.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          ad.dispose();
          _isInterstitialAdReady = false;
          loadInterstitialAd(); // Reload for next time
          onAdClosed(); // Execute the callback immediately after closing
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
          _isInterstitialAdReady = false;
          loadInterstitialAd();
          onAdClosed(); // If fails to show, just proceed with the callback
        },
      );
      
      ad.show();
    } else {
      // If ad isn't ready or already shown/disposed, just proceed
      debugPrint('Ad not ready, proceeding anyway');
      onAdClosed();
      // Try to load one for next time if not already loading
      if (!_isInterstitialAdReady) {
        loadInterstitialAd();
      }
    }
  }

}

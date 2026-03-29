import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import '../models/status_file.dart';
import '../providers/status_provider.dart';
import '../utils/ad_helper.dart';
import 'success_screen.dart';

class ImageViewScreen extends StatefulWidget {
  final StatusFile statusFile;

  const ImageViewScreen({super.key, required this.statusFile});

  @override
  State<ImageViewScreen> createState() => _ImageViewScreenState();
}

class _ImageViewScreenState extends State<ImageViewScreen> {
  @override
  void initState() {
    super.initState();
    AdHelper.loadInterstitialAd();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded, color: Colors.white),
            onPressed: () {
              Share.shareXFiles([XFile(widget.statusFile.path)], text: 'Check out this status!');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // The Image (with Hero)
          Expanded(
            child: Hero(
              tag: widget.statusFile.path,
              child: InteractiveViewer(
                minScale: 1.0,
                maxScale: 4.0,
                child: Image.file(
                  File(widget.statusFile.path),
                  fit: BoxFit.contain,
                ),
              ),
            ),
          ),
          
          // Action Area
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: Consumer<StatusProvider>(
              builder: (context, provider, child) {
                final isSaved = provider.savedStatuses.any((s) => s.path.endsWith(widget.statusFile.path.split('/').last));
                
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 60,
                  decoration: BoxDecoration(
                    color: isSaved ? Colors.black : Theme.of(context).primaryColor,
                    border: Border.all(color: Theme.of(context).primaryColor, width: 2),
                    borderRadius: BorderRadius.zero,
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: isSaved ? null : () {
                        final navigator = Navigator.of(context);
                        AdHelper.showInterstitialAd(
                          onAdClosed: () async {
                            final success = await provider.saveStatus(widget.statusFile.path);
                            if (success) {
                              navigator.pushReplacement(
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => const SuccessScreen(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(opacity: animation, child: child);
                                  },
                                ),
                              );
                            }
                          },
                        );
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            isSaved ? Icons.verified_user_rounded : Icons.arrow_downward_rounded,
                            color: isSaved ? Theme.of(context).primaryColor : Colors.black,
                            size: 24,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            isSaved ? 'SECURED' : 'EXTRACT',
                            style: GoogleFonts.outfit(
                              color: isSaved ? Theme.of(context).primaryColor : Colors.black,
                              fontSize: 18,
                              fontWeight: FontWeight.w900,
                              letterSpacing: 2.0,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

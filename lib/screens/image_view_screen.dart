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
      body: Stack(
        fit: StackFit.expand,
        children: [
          // The Image (with Hero)
          Hero(
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
          
          // Glassmorphic App Bar Area
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: EdgeInsets.only(top: MediaQuery.of(context).padding.top, left: 8, right: 8, bottom: 16),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Colors.black.withValues(alpha: 0.7),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
                    onPressed: () => Navigator.pop(context),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.share_rounded, color: Colors.white),
                    onPressed: () {
                      SharePlus.instance.shareUri(Uri.file(widget.statusFile.path), sharePositionOrigin: const Rect.fromLTWH(0, 0, 10, 10));
                    },
                  ),
                ],
              ),
            ),
          ),
          
          // Bottom Actions
          Positioned(
            bottom: 32,
            left: 32,
            right: 32,
            child: Consumer<StatusProvider>(
              builder: (context, provider, child) {
                final isSaved = provider.savedStatuses.any((s) => s.path.endsWith(widget.statusFile.path.split('/').last));
                
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 64,
                  decoration: BoxDecoration(
                    color: isSaved ? const Color(0xFF1E2732).withValues(alpha: 0.9) : const Color(0xFF00E676).withValues(alpha: 0.95),
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: isSaved ? Colors.black26 : const Color(0xFF00E676).withValues(alpha: 0.4),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(32),
                      onTap: isSaved ? null : () {
                        // Show Ad First, then Save
                        AdHelper.showInterstitialAd(
                          onAdClosed: () async {
                            final success = await provider.saveStatus(widget.statusFile.path);
                            if (!mounted) return;
                            
                            if (success) {
                              Navigator.pushReplacement(
                                context,
                                PageRouteBuilder(
                                  pageBuilder: (context, animation, secondaryAnimation) => const SuccessScreen(),
                                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                                    return FadeTransition(opacity: animation, child: child);
                                  },
                                ),
                              );
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Failed to save status.',
                                    style: GoogleFonts.inter(fontWeight: FontWeight.w600),
                                  ),
                                  backgroundColor: Colors.redAccent,
                                  behavior: SnackBarBehavior.floating,
                                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
                            isSaved ? Icons.check_circle_rounded : Icons.download_rounded,
                            color: Colors.white,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            isSaved ? 'Saved' : 'Save Status',
                            style: GoogleFonts.outfit(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
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

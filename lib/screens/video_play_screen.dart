import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:video_player/video_player.dart';
import 'package:chewie/chewie.dart';
import '../models/status_file.dart';
import '../providers/status_provider.dart';
import '../utils/ad_helper.dart';
import 'success_screen.dart';

class VideoPlayScreen extends StatefulWidget {
  final StatusFile statusFile;

  const VideoPlayScreen({super.key, required this.statusFile});

  @override
  State<VideoPlayScreen> createState() => _VideoPlayScreenState();
}

class _VideoPlayScreenState extends State<VideoPlayScreen> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;

  @override
  void initState() {
    super.initState();
    AdHelper.loadInterstitialAd();
    _initializePlayer();
  }

  Future<void> _initializePlayer() async {
    _videoPlayerController = VideoPlayerController.file(File(widget.statusFile.path));
    await _videoPlayerController.initialize();

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      autoPlay: true,
      looping: true,
      showControls: true,
      materialProgressColors: ChewieProgressColors(
        playedColor: Theme.of(context).primaryColor,
        handleColor: Theme.of(context).primaryColor,
        backgroundColor: Colors.white24,
        bufferedColor: Colors.white54,
      ),
      autoInitialize: true,
      errorBuilder: (context, errorMessage) {
        return Center(
          child: Text(
            errorMessage,
            style: const TextStyle(color: Colors.white),
          ),
        );
      },
    );
    setState(() {});
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_rounded),
            onPressed: () {
              Share.shareXFiles([XFile(widget.statusFile.path)], text: 'Check out this video status!');
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: Column(
        children: [
          // Video Player Area
          Expanded(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  decoration: ShapeDecoration(
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                      side: const BorderSide(color: Colors.white10, width: 1),
                    ),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: _chewieController != null && _chewieController!.videoPlayerController.value.isInitialized
                      ? Chewie(controller: _chewieController!)
                      : CircularProgressIndicator(color: Theme.of(context).primaryColor, strokeWidth: 2),
                ),
              ),
            ),
          ),
          
          // Action Area (No Overlay)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 40),
            child: Consumer<StatusProvider>(
              builder: (context, provider, child) {
                final isSaved = provider.savedStatuses.any((s) => s.path.endsWith(widget.statusFile.path.split('/').last));
                
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  height: 60,
                  decoration: ShapeDecoration(
                    color: isSaved ? Colors.black : Theme.of(context).primaryColor,
                    shape: BeveledRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide(color: Theme.of(context).primaryColor, width: 2),
                    ),
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
                            style: GoogleFonts.staatliches(
                              color: isSaved ? Theme.of(context).primaryColor : Colors.black,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
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

import 'dart:io';
import 'package:flutter/material.dart';
import '../models/status_file.dart';
import '../screens/image_view_screen.dart';
import '../screens/video_play_screen.dart';

class StatusGridItem extends StatelessWidget {
  final StatusFile statusFile;

  const StatusGridItem({super.key, required this.statusFile});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        if (statusFile.isVideo) {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => VideoPlayScreen(statusFile: statusFile),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        } else {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => ImageViewScreen(statusFile: statusFile),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        }
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.3),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Stack(
            fit: StackFit.expand,
            children: [
              // Hero animation target for images
              Hero(
                tag: statusFile.path,
                child: statusFile.isVideo 
                   // Simple placeholder for video thumbnail - normally would generate one natively but since we are reading directly from file system it is tricky without a separate native plugin. So we show an icon or attempt to show first frame natively.
                    ? Container(color: const Color(0xFF1E2732))
                    : Image.file(
                        File(statusFile.path),
                        fit: BoxFit.cover,
                      ),
              ),
              
              if (statusFile.isVideo)
                Container(
                  color: Colors.black.withOpacity(0.3),
                  child: const Center(
                    child: Icon(
                      Icons.play_circle_fill_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

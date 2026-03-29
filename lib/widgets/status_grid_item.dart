import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_thumbnail/video_thumbnail.dart';
import 'package:path_provider/path_provider.dart';
import '../models/status_file.dart';
import '../providers/status_provider.dart';
import '../screens/image_view_screen.dart';
import '../screens/video_play_screen.dart';

class StatusGridItem extends StatelessWidget {
  final StatusFile statusFile;

  const StatusGridItem({super.key, required this.statusFile});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StatusProvider>(context);
    final isSelected = provider.isSelected(statusFile.path);

    return GestureDetector(
      onLongPress: () {
        provider.toggleSelection(statusFile.path);
      },
      onTap: () {
        if (provider.isSelectionMode) {
          provider.toggleSelection(statusFile.path);
        } else {
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
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.zero,
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.white12,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Stack(
          fit: StackFit.expand,
          children: [
            Hero(
              tag: statusFile.path,
              child: statusFile.isVideo 
                  ? _VideoThumbnailWidget(videoPath: statusFile.path)
                  : Image.file(
                      File(statusFile.path),
                      fit: BoxFit.cover,
                    ),
            ),
            
            // Tactical Overlay for Videos
            if (statusFile.isVideo)
              Positioned(
                top: 8,
                left: 8,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.9),
                  child: const Text(
                    'VID',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),

              if (statusFile.isVideo)
                const Center(
                  child: Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.white70,
                    size: 40,
                  ),
                ),

            // Selection Overlay
            if (isSelected)
              Container(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      shape: BoxShape.rectangle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.black,
                      size: 32,
                    ),
                  ),
                ),
              ),
            
            // Tactical Corner Accents
            if (isSelected)
              Positioned(
                bottom: 0,
                right: 0,
                child: CustomPaint(
                  size: const Size(20, 20),
                  painter: _TacticalCornerPainter(color: Theme.of(context).primaryColor),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _VideoThumbnailWidget extends StatelessWidget {
  final String videoPath;

  const _VideoThumbnailWidget({required this.videoPath});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: VideoThumbnail.thumbnailFile(
        video: videoPath,
        thumbnailPath: (await getTemporaryDirectory()).path,
        imageFormat: ImageFormat.JPEG,
        maxWidth: 256,
        quality: 50,
      ),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.done && snapshot.hasData && snapshot.data != null) {
          return Image.file(
            File(snapshot.data!),
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => Container(color: Colors.black),
          );
        }
        return Container(
          color: Colors.black26,
          child: Center(
            child: CircularProgressIndicator(
              strokeWidth: 1,
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor.withValues(alpha: 0.3)),
            ),
          ),
        );
      },
    );
  }
}

class _TacticalCornerPainter extends CustomPainter {
  final Color color;
  _TacticalCornerPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;

    final path = Path()
      ..moveTo(size.width, 0)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height);
    
    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

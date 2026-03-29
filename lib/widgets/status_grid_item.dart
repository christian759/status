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
      onLongPress: () => provider.toggleSelection(statusFile.path),
      onTap: () {
        if (provider.isSelectionMode) {
          provider.toggleSelection(statusFile.path);
        } else {
          Navigator.push(
            context,
            PageRouteBuilder(
              pageBuilder: (context, animation, secondaryAnimation) => 
                statusFile.isVideo ? VideoPlayScreen(statusFile: statusFile) : ImageViewScreen(statusFile: statusFile),
              transitionsBuilder: (context, animation, secondaryAnimation, child) {
                return FadeTransition(opacity: animation, child: child);
              },
            ),
          );
        }
      },
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        decoration: ShapeDecoration(
          shape: BeveledRectangleBorder(
            borderRadius: BorderRadius.circular(isSelected ? 16 : 8),
            side: BorderSide(
              color: isSelected ? Theme.of(context).primaryColor : Colors.white10,
              width: isSelected ? 3 : 1,
            ),
          ),
          shadows: isSelected ? [
            BoxShadow(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
              blurRadius: 15,
              spreadRadius: -2,
            )
          ] : [],
        ),
        clipBehavior: Clip.antiAlias,
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
            
            // Texture Overlay
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Colors.white.withValues(alpha: 0.05),
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.2),
                    ],
                  ),
                ),
              ),
            ),

            // Video Indicator
            if (statusFile.isVideo)
              Positioned(
                top: 10,
                right: 10,
                child: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: ShapeDecoration(
                    color: Theme.of(context).primaryColor,
                    shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  ),
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.black,
                    size: 16,
                  ),
                ),
              ),

            // Selection Check (Obsidian style)
            if (isSelected)
              Positioned(
                left: 10,
                top: 10,
                child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const ShapeDecoration(
                    color: Colors.black,
                    shape: CircleBorder(),
                  ),
                  child: Icon(
                    Icons.check_rounded,
                    color: Theme.of(context).primaryColor,
                    size: 16,
                  ),
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
    final provider = Provider.of<StatusProvider>(context, listen: false);
    
    return FutureBuilder<String?>(
      future: provider.getThumbnail(videoPath),
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
              strokeWidth: 2,
              valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor.withValues(alpha: 0.1)),
            ),
          ),
        );
      },
    );
  }
}

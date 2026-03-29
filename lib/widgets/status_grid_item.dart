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
            width: isSelected ? 3 : 1,
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
            
            // Minimalist Video Indicator
            if (statusFile.isVideo)
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  color: Theme.of(context).primaryColor,
                  child: const Icon(
                    Icons.play_arrow_rounded,
                    color: Colors.black,
                    size: 16,
                  ),
                ),
              ),

            // Selection Overlay (Solid)
            if (isSelected)
              Container(
                color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    color: Theme.of(context).primaryColor,
                    child: const Icon(
                      Icons.check_rounded,
                      color: Colors.black,
                      size: 32,
                    ),
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

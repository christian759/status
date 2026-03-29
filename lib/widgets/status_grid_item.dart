import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
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
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Theme.of(context).primaryColor : Colors.transparent,
            width: 4,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.5),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(isSelected ? 4 : 8),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Hero(
                tag: statusFile.path,
                child: statusFile.isVideo 
                    ? Container(color: const Color(0xFF1E1E1E))
                    : Image.file(
                        File(statusFile.path),
                        fit: BoxFit.cover,
                      ),
              ),
              
              if (statusFile.isVideo)
                Container(
                  color: Colors.black.withValues(alpha: 0.3),
                  child: const Center(
                    child: Icon(
                      Icons.play_circle_fill_rounded,
                      color: Colors.white,
                      size: 48,
                    ),
                  ),
                ),

              if (isSelected)
                Container(
                  color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
                  child: const Center(
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: Colors.white,
                      size: 56,
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

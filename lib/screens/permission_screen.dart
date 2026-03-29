import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/status_provider.dart';
import 'home_screen.dart';

class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 60.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Large Typographic Header
              Text(
                'STATUS\nSAVER',
                style: Theme.of(context).textTheme.displayLarge,
              ),
              const SizedBox(height: 20),
              Container(
                height: 8,
                width: 80,
                color: Theme.of(context).primaryColor,
              ),
              const SizedBox(height: 60),
              
              // App Description
              Text(
                'COLLECT AND ARCHIVE.',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.w900,
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 2,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'A MINIMALIST TOOL DESIGNED TO EXTRACT AND SECURE WHATSAPP MEDIA DIRECTLY FROM YOUR DEVICE STORAGE.',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  height: 1.5,
                  letterSpacing: 0.5,
                ),
              ),
              
              const Spacer(),
              
              // Solid Action Button
              SizedBox(
                width: double.infinity,
                child: Consumer<StatusProvider>(
                  builder: (context, provider, child) {
                    return ElevatedButton(
                      onPressed: () => provider.requestPermission(),
                      child: const Text('BEGIN EXTRACTION'),
                    );
                  },
                ),
              ),
              
              const SizedBox(height: 48),
              
              // Footer text
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'VERSION 1.0.2',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white24,
                    ),
                  ),
                  Text(
                    '© 2026',
                    style: GoogleFonts.outfit(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white24,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

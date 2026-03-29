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
      body: Stack(
        children: [
          // Background Rare Typo
          Positioned(
            right: -40,
            top: 60,
            child: Text(
              'VAULT',
              style: GoogleFonts.staatliches(
                fontSize: 200,
                color: Colors.white.withValues(alpha: 0.02),
                letterSpacing: 20,
              ),
            ),
          ),
          
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 40.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 40),
                  Text(
                    'STATUS\nARCHIVE',
                    style: Theme.of(context).textTheme.displayLarge,
                  ),
                  const SizedBox(height: 12),
                  Container(
                    height: 4,
                    width: 60,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 60),
                  
                  Text(
                    'PREMIUM MEDIA RECOVERY.',
                    style: GoogleFonts.staatliches(
                      fontSize: 24,
                      color: Theme.of(context).primaryColor,
                      letterSpacing: 3,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'EXTRACT HIGH-RESOLUTION STATUS MEDIA DIRECTLY FROM THE DEVICE STREAM. SECURE YOUR ARCHIVE WITH THE OBSIDIAN PROTOCOL.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      height: 1.6,
                      letterSpacing: 1.0,
                    ),
                  ),
                  
                  const Spacer(),
                  
                  SizedBox(
                    width: double.infinity,
                    child: Consumer<StatusProvider>(
                      builder: (context, provider, child) {
                        return ElevatedButton(
                          onPressed: () => provider.requestPermission(),
                          child: const Text('INITIALIZE ACCESS'),
                        );
                      },
                    ),
                  ),
                  
                  const SizedBox(height: 40),
                  
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'PROTO v1.0',
                        style: GoogleFonts.staatliches(
                          fontSize: 14,
                          color: Colors.white12,
                          letterSpacing: 2,
                        ),
                      ),
                      Text(
                        '© 2026 CEO3',
                        style: GoogleFonts.staatliches(
                          fontSize: 14,
                          color: Colors.white12,
                          letterSpacing: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

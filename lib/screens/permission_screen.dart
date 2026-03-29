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
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          // Tactical Grid Overlay (Simulated with CustomPaint)
          Positioned.fill(
            child: CustomPaint(
              painter: _TacticalGridPainter(color: Colors.white.withValues(alpha: 0.03)),
            ),
          ),
          
          SafeArea(
            child: Center(
              child: Padding(
                padding: const EdgeInsets.all(40.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Tactical Header
                    Text(
                      'STATUS_SAVER_v1.0',
                      style: GoogleFonts.shareTechMono(
                        color: Theme.of(context).primaryColor,
                        fontSize: 14,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 2,
                      width: 60,
                      color: Theme.of(context).primaryColor,
                    ),
                    const SizedBox(height: 48),
                    
                    Text(
                      'SYSTEM\nINITIALIZATION',
                      style: GoogleFonts.shareTechMono(
                        fontSize: 40,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        height: 1,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Description
                    Text(
                      'SECURE AND EXTRACT WHATSAPP STATUSES DIRECTLY FROM YOUR SYSTEM STORAGE. NO TRACE LEFT BEHIND.',
                      style: GoogleFonts.jetBrainsMono(
                        fontSize: 14,
                        color: Colors.white70,
                        height: 1.8,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 60),
                    
                    // Detailed Requirements
                    _buildRequirement(context, 'STORAGE_ACCESS', 'REQUIRED FOR READ/WRITE OPERATIONS'),
                    _buildRequirement(context, 'SYSTEM_INTEGRITY', 'OPERATIONAL'),
                    
                    const SizedBox(height: 80),
                    
                    // Button
                    Consumer<StatusProvider>(
                      builder: (context, provider, child) {
                        return SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () async {
                              await provider.requestPermission();
                            },
                            child: const Text('GET CLEARANCE'),
                          ),
                        );
                      },
                    ),
                    
                    const SizedBox(height: 24),
                    Center(
                      child: Text(
                        'AWAITING USER INPUT...',
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 10,
                          color: Theme.of(context).primaryColor.withValues(alpha: 0.5),
                          letterSpacing: 2,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRequirement(BuildContext context, String label, String status) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              border: Border.all(color: Theme.of(context).primaryColor, width: 1),
            ),
            child: Icon(Icons.check, size: 12, color: Theme.of(context).primaryColor),
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.shareTechMono(color: Colors.white, fontSize: 12),
              ),
              Text(
                status,
                style: GoogleFonts.jetBrainsMono(color: Colors.white38, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _TacticalGridPainter extends CustomPainter {
  final Color color;
  _TacticalGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1;

    const double step = 30;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}

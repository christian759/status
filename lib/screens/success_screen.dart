import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> with SingleTickerProviderStateMixin {
  AnimationController? _controller;
  Animation<double>? _scaleAnimation;
  Animation<double>? _fadeAnimation;

  @override
  void initState() {
    super.initState();
    final controller = AnimationController(
       vsync: this, 
       duration: const Duration(milliseconds: 800)
    );
    _controller = controller;

    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: Curves.elasticOut),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: controller, curve: const Interval(0.0, 0.5, curve: Curves.easeIn)),
    );

    controller.forward();
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_controller == null || _scaleAnimation == null || _fadeAnimation == null) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 80.0),
              child: AnimatedBuilder(
                animation: _controller!,
                builder: (context, child) {
                  final scale = _scaleAnimation;
                  final fade = _fadeAnimation;
                  
                  if (scale == null || fade == null) {
                    return const SizedBox.shrink();
                  }

                  return Opacity(
                    opacity: fade.value,
                    child: Transform.scale(
                      scale: scale.value,
                      child: Column(

                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Rounded Success Icon
                          Container(
                            padding: const EdgeInsets.all(40),
                            decoration: BoxDecoration(
                              color: Theme.of(context).primaryColor,
                              borderRadius: BorderRadius.circular(24),
                            ),
                            child: const Icon(
                              Icons.check_rounded,
                              size: 80,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 60),
                          
                          // Success Text
                          Text(
                            'SUCCESSFULLY\nSAVED',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.displayMedium,
                          ),
                          const SizedBox(height: 24),
                          Text(
                            'THE STATUS HAS BEEN SAVED TO YOUR GALLERY.',
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 80),
                          
                          // Back Button
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text('DISMISS'),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}


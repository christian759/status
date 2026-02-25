import 'package:flutter/material.dart';

class StatusSummaryCard extends StatelessWidget {
  final String label;
  final String value;
  final String note;
  final IconData icon;
  final Color accent;

  const StatusSummaryCard({
    super.key,
    required this.label,
    required this.value,
    required this.note,
    required this.icon,
    required this.accent,
  });

  @override
  Widget build(BuildContext context) {
    final startColor = _withOpacityColor(accent, 0.95);
    final endColor = _withOpacityColor(accent, 0.65);

    return Container(
      height: 120,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(18),
        gradient: LinearGradient(
          colors: [startColor, endColor],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 14,
            offset: Offset(0, 8),
          ),
        ],
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.white24,
            child: Icon(icon, color: Colors.white, size: 20),
          ),
          const Spacer(),
          Text(
            value,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white70,
                  fontWeight: FontWeight.w500,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            note,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white60,
                ),
          ),
        ],
      ),
    );
  }
}

Color _withOpacityColor(Color color, double opacity) {
  final channels = color.toARGB32();
  final alpha = ((opacity * 255).round()).clamp(0, 255).toInt();
  return Color.fromARGB(
    alpha,
    _channel(channels, 16),
    _channel(channels, 8),
    _channel(channels, 0),
  );
}

int _channel(int value, int shift) => (value >> shift) & 0xFF;

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';

import '../models/status_item.dart';
import '../providers/status_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/status_summary_card.dart';
import '../widgets/status_tile.dart';

class StatusSaverScreen extends StatefulWidget {
  const StatusSaverScreen({super.key});

  @override
  State<StatusSaverScreen> createState() => _StatusSaverScreenState();
}

class _StatusSaverScreenState extends State<StatusSaverScreen> {
  bool _hasFetched = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_hasFetched) {
      _hasFetched = true;
      context.read<StatusProvider>().loadStatuses();
    }
  }

  Future<void> _handleSave(StatusItem status) async {
    final provider = context.read<StatusProvider>();
    try {
      final savedPath = await provider.saveStatus(status);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Status copied to $savedPath'),
            duration: const Duration(seconds: 3),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to save this status right now.'),
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    }
  }

  Future<void> _onRefresh() async {
    await context.read<StatusProvider>().loadStatuses();
  }

  Widget _buildChip(String label, String value, Color accent) {
    return Chip(
      backgroundColor: _withAlpha(accent, 0.15),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      label: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            value,
            style: TextStyle(
              color: accent.darken(),
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              color: accent.darken(0.4),
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorBanner(String message) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red.shade100,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Storage permission required',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Text(message),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: () => openAppSettings(),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.redAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: const Text('Open Settings'),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.hourglass_empty, size: 64, color: Colors.grey.shade400),
          const SizedBox(height: 20),
          const Text(
            'No statuses yet',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 12),
          const Text(
            'Open WhatsApp, view a status, and refresh to see it inside StatusVault.',
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards(StatusProvider provider, String syncLabel) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 14),
      sliver: SliverGrid(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
        delegate: SliverChildListDelegate(
          [
            StatusSummaryCard(
              label: 'Available',
              value: provider.statuses.length.toString(),
              note: 'Refreshed $syncLabel',
              icon: Icons.visibility,
              accent: AppTheme.primary,
            ),
            StatusSummaryCard(
              label: 'Saved',
              value: provider.savedCount.toString(),
              note: 'Saved to Pictures/Movies',
              icon: Icons.download_rounded,
              accent: AppTheme.primaryAccent,
            ),
            StatusSummaryCard(
              label: 'Videos',
              value: provider.videoCount.toString(),
              note: 'Eligible for movies folder',
              icon: Icons.video_library,
              accent: Colors.purpleAccent,
            ),
            StatusSummaryCard(
              label: 'Last scan',
              value: syncLabel,
              note: 'Tap refresh to re-scan',
              icon: Icons.schedule,
              accent: Colors.tealAccent.shade700,
            ),
          ],
        ),
      ),
    );
  }

  SliverPadding _buildStatusGrid(StatusProvider provider) {
    return SliverPadding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      sliver: SliverGrid(
        delegate: SliverChildBuilderDelegate(
          (context, index) {
            final status = provider.statuses[index];
            return StatusTile(
              status: status,
              saved: provider.isSaved(status),
              onSave: () => _handleSave(status),
            );
          },
          childCount: provider.statuses.length,
        ),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 16,
          mainAxisSpacing: 16,
          childAspectRatio: 0.74,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StatusProvider>();
    final lastSync = provider.lastSync;
    final syncLabel = lastSync == null
        ? 'Not scanned yet'
        : DateFormat('MMM d, hh:mm a').format(lastSync);

    final slivers = <Widget>[
      SliverAppBar(
        pinned: true,
        expandedHeight: 260,
        backgroundColor: Colors.transparent,
        elevation: 0,
        flexibleSpace: FlexibleSpaceBar(
          background: Container(
            decoration: const BoxDecoration(
              gradient: AppTheme.headerGradient,
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(36),
                bottomRight: Radius.circular(36),
              ),
            ),
            padding: const EdgeInsets.fromLTRB(24, 56, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: const [
                    Icon(Icons.shield, color: Colors.white, size: 32),
                    SizedBox(width: 12),
                    Text(
                      'StatusVault',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Text(
                  'Safely save WhatsApp stories and revisit them any time.',
                  style: TextStyle(color: Colors.white70, fontSize: 15),
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    ElevatedButton.icon(
                      onPressed: _onRefresh,
                      icon: const Icon(Icons.refresh),
                      label: const Text('Refresh scan'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppTheme.primary,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 18,
                          vertical: 12,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      syncLabel,
                      style: const TextStyle(
                        color: Colors.white70,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 10,
                  runSpacing: 6,
                  children: [
                    _buildChip('Statuses', provider.statuses.length.toString(),
                        AppTheme.primary),
                    _buildChip('Saved', provider.savedCount.toString(),
                        AppTheme.primaryAccent),
                    _buildChip('Videos', provider.videoCount.toString(),
                        Colors.purpleAccent),
                  ],
                ),
              ],
            ),
          ),
        ),
        title: const Text('StatusVault'),
        foregroundColor: Colors.white,
      ),
      SliverToBoxAdapter(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(20, 28, 20, 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Insights',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Text(
                provider.statuses.isEmpty ? '0 new' :
                    '${provider.statuses.length} new',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
        ),
      ),
      _buildSummaryCards(provider, syncLabel),
    ];

    if (provider.errorMessage != null) {
      slivers.add(SliverToBoxAdapter(child: _buildErrorBanner(provider.errorMessage!)));
    }

    if (provider.isLoading && provider.statuses.isEmpty) {
      slivers.add(
        const SliverFillRemaining(
          hasScrollBody: false,
          child: Center(child: CircularProgressIndicator()),
        ),
      );
    } else if (provider.statuses.isEmpty) {
      slivers.add(
        SliverFillRemaining(
          hasScrollBody: false,
          child: _buildEmptyState(),
        ),
      );
    } else {
      slivers.add(
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 6),
            child: Text(
              'Recent Stories',
              style: Theme.of(context)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: 20),
            ),
          ),
        ),
      );
      slivers.add(_buildStatusGrid(provider));
    }

    return Scaffold(
      backgroundColor: AppTheme.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onRefresh,
        icon: const Icon(Icons.sync),
        label: const Text('Rescan now'),
      ),
      body: RefreshIndicator(
        onRefresh: _onRefresh,
        child: CustomScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          slivers: slivers,
        ),
      ),
    );
  }
}

extension on Color {
  Color darken([double amount = 0.2]) {
    final hsl = HSLColor.fromColor(this);
    final lightness = (hsl.lightness - amount).clamp(0.0, 1.0);
    return hsl.withLightness(lightness).toColor();
  }
}

Color _withAlpha(Color color, double opacity) {
  final alpha = (opacity * 255).round().clamp(0, 255);
  return color.withAlpha(alpha);
}

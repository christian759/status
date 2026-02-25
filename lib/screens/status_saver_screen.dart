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
          ),
        );
      }
    } catch (_) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Unable to save this status right now.'),
          ),
        );
      }
    }
  }

  Future<void> _onRefresh() async {
    await context.read<StatusProvider>().loadStatuses();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StatusProvider>();
    final lastSync = provider.lastSync;
    final syncLabel = lastSync == null
        ? 'Scanning soon'
        : 'Updated ${DateFormat('hh:mm a').format(lastSync)}';

    return Scaffold(
      backgroundColor: AppTheme.background,
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _onRefresh,
        icon: const Icon(Icons.refresh),
        label: const Text('Scan again'),
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _onRefresh,
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              Container(
                height: 280,
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                decoration: const BoxDecoration(
                  gradient: AppTheme.headerGradient,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(36),
                    bottomRight: Radius.circular(36),
                  ),
                ),
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
                    const SizedBox(height: 16),
                    const Text(
                      'Securely save, organize, and revisit every WhatsApp status without leaving the app.',
                      style: TextStyle(color: Colors.white70, fontSize: 16),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        ElevatedButton.icon(
                          onPressed: _onRefresh,
                          icon: const Icon(Icons.visibility),
                          label: const Text('Scan statuses'),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppTheme.primary,
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 12),
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
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Status Insights',
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    Text(
                      provider.statuses.isEmpty ? '0 new' : '${provider.statuses.length} new',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: GridView.count(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 12,
                  childAspectRatio: 1.28,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    StatusSummaryCard(
                      label: 'Available statuses',
                      value: provider.statuses.length.toString(),
                      note: syncLabel,
                      icon: Icons.visibility,
                      accent: AppTheme.primary,
                    ),
                    StatusSummaryCard(
                      label: 'Saved locally',
                      value: provider.savedCount.toString(),
                      note: 'Saved to StatusVault',
                      icon: Icons.download_done,
                      accent: AppTheme.primaryAccent,
                    ),
                    StatusSummaryCard(
                      label: 'Video statuses',
                      value: provider.videoCount.toString(),
                      note: 'Auto-detected videos',
                      icon: Icons.video_camera_back,
                      accent: Colors.purpleAccent,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
                child: Text(
                  'Recent Stories',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontSize: 20),
                ),
              ),
              ..._buildStatusSection(provider),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _buildStatusSection(StatusProvider provider) {
    if (provider.isLoading) {
      return [
        const Padding(
          padding: EdgeInsets.symmetric(vertical: 40),
          child: Center(child: CircularProgressIndicator()),
        ),
      ];
    }

    if (provider.errorMessage != null) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Column(
            children: [
              Text(
                provider.errorMessage!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => openAppSettings(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                ),
                child: const Text('Open settings'),
              ),
            ],
          ),
        ),
      ];
    }

    if (provider.statuses.isEmpty) {
      return [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 48),
          child: Column(
            children: const [
              Icon(Icons.hourglass_empty, size: 60, color: Colors.black26),
              SizedBox(height: 16),
              Text(
                'No statuses detected yet. Launch WhatsApp, view a status, and then scan again.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ];
    }

    return [
      Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: provider.statuses.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final status = provider.statuses[index];
            return StatusTile(
              status: status,
              saved: provider.isSaved(status),
              onSave: () => _handleSave(status),
            );
          },
        ),
      ),
    ];
  }
}

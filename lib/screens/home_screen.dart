import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/status_provider.dart';
import '../widgets/status_grid_item.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<StatusProvider>(context);

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: provider.isSelectionMode
            ? Text(
                '${provider.selectedPaths.length} Selected',
                style: GoogleFonts.outfit(fontWeight: FontWeight.w900, color: Theme.of(context).primaryColor),
              )
            : Text(
                'STATUS SAVER',
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.w900,
                  letterSpacing: 2.0,
                ),
              ),
        leading: provider.isSelectionMode
            ? IconButton(
                icon: const Icon(Icons.close_rounded),
                onPressed: () => provider.clearSelection(),
              )
            : null,
        actions: [
          if (provider.isSelectionMode)
            IconButton(
              icon: const Icon(Icons.save_alt_rounded),
              tooltip: 'SAVE SELECTED',
              onPressed: () {
                AdHelper.showInterstitialAd(
                  onAdClosed: () async {
                    final count = await provider.saveMultipleStatuses();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('[$count] STATUSES SECURED'),
                          backgroundColor: Theme.of(context).primaryColor,
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    }
                  },
                );
              },
            ),
          if (!provider.isSelectionMode)
            IconButton(
              icon: const Icon(Icons.refresh_rounded),
              onPressed: () => provider.fetchStatuses(),
            ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'IMAGES'),
            Tab(text: 'VIDEOS'),
            Tab(text: 'SAVED'),
          ],
        ),
      ),
      body: Consumer<StatusProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                strokeWidth: 6,
              ),
            );
          }

          if (provider.errorMessage.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(32.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.error_outline_rounded, size: 80, color: Theme.of(context).primaryColor),
                    const SizedBox(height: 24),
                    Text(
                      provider.errorMessage,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 32),
                    ElevatedButton(
                      onPressed: () => provider.fetchStatuses(),
                      child: const Text('RETRY'),
                    ),
                  ],
                ),
              ),
            );
          }

          return TabBarView(
            controller: _tabController,
            children: [
              _buildGrid(provider.images),
              _buildGrid(provider.videos),
              _buildGrid(provider.savedStatuses),
            ],
          );
        },
      ),
    );
  }

  Widget _buildGrid(List statuses) {
    if (statuses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox_rounded, size: 100, color: Theme.of(context).primaryColor.withValues(alpha: 0.2)),
            const SizedBox(height: 24),
            Text(
              'NO STATUSES FOUND',
              style: GoogleFonts.outfit(
                color: Colors.white24,
                fontSize: 24,
                fontWeight: FontWeight.w900,
                letterSpacing: 1.5,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: Colors.white,
      backgroundColor: Theme.of(context).primaryColor,
      strokeWidth: 3,
      onRefresh: () async {
        final provider = Provider.of<StatusProvider>(context, listen: false);
        await provider.fetchStatuses();
        await provider.fetchSavedStatuses();
      },
      child: AnimationLimiter(
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 0.7, // Bolder, taller items
          ),
          itemCount: statuses.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 400),
              columnCount: 2,
              child: ScaleAnimation(
                scale: 0.8,
                child: FadeInAnimation(
                  child: StatusGridItem(statusFile: statuses[index]),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

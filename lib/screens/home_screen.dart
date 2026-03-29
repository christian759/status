import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:google_fonts/google_fonts.dart';
import '../providers/status_provider.dart';
import '../utils/ad_helper.dart';
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
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: Text(
          provider.isSelectionMode
              ? '${provider.selectedPaths.length} SELECTED'
              : 'STATUS SAVER',
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
              icon: const Icon(Icons.arrow_downward_rounded),
              tooltip: 'EXTRACT',
              onPressed: () {
                AdHelper.showInterstitialAd(
                  onAdClosed: () async {
                    final count = await provider.saveMultipleStatuses();
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('$count ASSETS SECURED', style: const TextStyle(fontWeight: FontWeight.w900)),
                          backgroundColor: Theme.of(context).primaryColor,
                          behavior: SnackBarBehavior.floating,
                          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
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
      body: Column(
        children: [
          const Divider(height: 1, thickness: 1),
          Expanded(
            child: Consumer<StatusProvider>(
              builder: (context, provider, child) {
                if (provider.isLoading) {
                  return Center(
                    child: CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                      strokeWidth: 2,
                    ),
                  );
                }

                if (provider.errorMessage.isNotEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.all(40.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('ERROR OCCURRED', style: Theme.of(context).textTheme.displayMedium),
                          const SizedBox(height: 16),
                          Text(provider.errorMessage, textAlign: TextAlign.center),
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
                    _buildGrid(provider, provider.images),
                    _buildGrid(provider, provider.videos),
                    _buildGrid(provider, provider.savedStatuses),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(StatusProvider provider, List statuses) {
    if (statuses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'EMPTY',
              style: GoogleFonts.outfit(
                color: Colors.white10,
                fontSize: 80,
                fontWeight: FontWeight.w900,
                letterSpacing: -4,
              ),
            ),
            Text(
              'ARCHIVE IS CURRENTLY STAGNANT',
              style: GoogleFonts.outfit(
                color: Colors.white24,
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      color: Colors.black,
      backgroundColor: Theme.of(context).primaryColor,
      onRefresh: () async {
        await provider.fetchStatuses();
        await provider.fetchSavedStatuses();
      },
      child: GridView.builder(
        padding: EdgeInsets.zero,
        physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 0,
          mainAxisSpacing: 0,
          childAspectRatio: 1,
        ),
        itemCount: statuses.length,
        itemBuilder: (context, index) {
          return StatusGridItem(
            statusFile: statuses[index],
            key: ValueKey(statuses[index].path),
          );
        },
      ),
    );
  }
}

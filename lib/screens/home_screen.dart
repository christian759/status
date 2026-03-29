import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
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
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) => [
          SliverAppBar(
            expandedHeight: 140,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
              title: Text(
                provider.isSelectionMode
                    ? '${provider.selectedPaths.length} SELECTED'
                    : 'STATUSES',
                style: GoogleFonts.outfit(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: provider.isSelectionMode ? Theme.of(context).primaryColor : Colors.white,
                  letterSpacing: 2,
                ),
              ),
              background: Container(
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.black, Colors.black87],
                  ),
                ),
              ),
            ),
            actions: [
              if (provider.isSelectionMode)
                IconButton(
                  icon: const Icon(Icons.close_rounded),
                  onPressed: () => provider.clearSelection(),
                ),
              if (provider.isSelectionMode)
                IconButton(
                  icon: const Icon(Icons.arrow_downward_rounded),
                  onPressed: () {
                    AdHelper.showInterstitialAd(
                      onAdClosed: () async {
                        final count = await provider.saveMultipleStatuses();
                        if (mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('$count STATUSES SAVED'),
                              backgroundColor: Theme.of(context).primaryColor,
                              behavior: SnackBarBehavior.floating,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
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
        ],
        body: Consumer<StatusProvider>(
          builder: (context, provider, child) {
            return Stack(
              children: [
                TabBarView(
                  controller: _tabController,
                  children: [
                    _buildGrid(provider, provider.images),
                    _buildGrid(provider, provider.videos),
                    _buildGrid(provider, provider.savedStatuses),
                  ],
                ),
                if (provider.isLoading)
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: LinearProgressIndicator(
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                      minHeight: 2,
                    ),
                  ),
              ],
            );
          },
        ),

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
                color: Colors.white.withValues(alpha: 0.05),
                fontSize: 80,
                fontWeight: FontWeight.bold,
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
      child: AnimationLimiter(
        child: GridView.builder(
          padding: const EdgeInsets.all(12),
          physics: const BouncingScrollPhysics(parent: AlwaysScrollableScrollPhysics()),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 1.0,
          ),
          itemCount: statuses.length,
          itemBuilder: (context, index) {
            return AnimationConfiguration.staggeredGrid(
              position: index,
              duration: const Duration(milliseconds: 400),
              columnCount: 2,
              child: FadeInAnimation(
                child: ScaleAnimation(
                  scale: 0.95,
                  child: StatusGridItem(
                    statusFile: statuses[index],
                    key: ValueKey(statuses[index].path),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

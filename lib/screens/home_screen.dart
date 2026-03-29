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
            expandedHeight: 180,
            floating: false,
            pinned: true,
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            flexibleSpace: FlexibleSpaceBar(
              titlePadding: const EdgeInsets.only(left: 20, bottom: 60),
              title: Text(
                provider.isSelectionMode
                    ? '${provider.selectedPaths.length} ASSETS'
                    : 'ARCHIVE',
                style: GoogleFonts.staatliches(
                  fontSize: 32,
                  color: Theme.of(context).primaryColor,
                  letterSpacing: 4,
                ),
              ),
              background: Container(
                color: Theme.of(context).scaffoldBackgroundColor,
                child: Stack(
                  children: [
                    Positioned(
                      right: -20,
                      top: 40,
                      child: Text(
                        '0X',
                        style: GoogleFonts.staatliches(
                          fontSize: 180,
                          color: Colors.white.withValues(alpha: 0.03),
                        ),
                      ),
                    ),
                  ],
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
                              content: Text('$count ASSETS SECURED'),
                              backgroundColor: Theme.of(context).primaryColor,
                              behavior: SnackBarBehavior.floating,
                              shape: BeveledRectangleBorder(borderRadius: BorderRadius.circular(4)),
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
            if (provider.isLoading) {
              return Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
                  strokeWidth: 2,
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
    );
  }

  Widget _buildGrid(StatusProvider provider, List statuses) {
    if (statuses.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'VOID',
              style: GoogleFonts.staatliches(
                color: Colors.white.withValues(alpha: 0.05),
                fontSize: 100,
                letterSpacing: 10,
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
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: MasonryGridView.count(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            itemCount: statuses.length,
            itemBuilder: (context, index) {
              return AnimationConfiguration.staggeredGrid(
                position: index,
                duration: const Duration(milliseconds: 500),
                columnCount: 2,
                child: FadeInAnimation(
                  child: ScaleAnimation(
                    scale: 0.9,
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
      ),
    );
  }
}

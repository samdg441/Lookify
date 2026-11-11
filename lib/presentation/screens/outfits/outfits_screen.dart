import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/providers.dart';
import '../../widgets/outfit_card.dart';
import 'ai_suggestions_panel.dart';
import '../../widgets/category_filter.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';

class OutfitsScreen extends ConsumerStatefulWidget {
  const OutfitsScreen({super.key});

  @override
  ConsumerState<OutfitsScreen> createState() => _OutfitsScreenState();
}

class _OutfitsScreenState extends ConsumerState<OutfitsScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context),
            const SizedBox(height: 16),
            _buildTabBar(),
            const SizedBox(height: 4),
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _MySavedOutfits(),
                  const AiSuggestionsPanel(),
                ],
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/outfits/builder'),
        child: const Icon(Icons.add),
      ).animate().scale(delay: 300.ms),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Text(
        'Outfits',
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  Widget _buildTabBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 44,
        decoration: BoxDecoration(
          color: AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
        ),
        child: TabBar(
          controller: _tabController,
          indicator: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(10),
          ),
          indicatorSize: TabBarIndicatorSize.tab,
          labelColor: AppColors.background,
          unselectedLabelColor: AppColors.textSecondary,
          labelStyle: const TextStyle(
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
          dividerColor: Colors.transparent,
          tabs: const [
            Tab(text: 'My Outfits'),
            Tab(text: 'AI Suggestions'),
          ],
        ),
      ),
    );
  }
}

class _MySavedOutfits extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outfitsAsync = ref.watch(outfitsProvider);
    final selectedOccasion = ref.watch(selectedOccasionProvider);

    return Column(
      children: [
        const SizedBox(height: 12),
        CategoryFilter(
          categories: AppConstants.occasions,
          selected: selectedOccasion,
          onSelected: (o) =>
              ref.read(selectedOccasionProvider.notifier).state = o,
        ),
        const SizedBox(height: 12),
        Expanded(
          child: outfitsAsync.when(
            loading: () => const LoadingIndicator(),
            error: (e, _) => ErrorView(
              message: 'Failed to load outfits',
              onRetry: () => ref.invalidate(outfitsProvider),
            ),
            data: (outfits) => outfits.isEmpty
                ? EmptyView(
                    icon: Icons.checkroom_outlined,
                    title: 'No outfits yet',
                    subtitle: 'Build your first outfit by combining\ngarments from your closet',
                    action: ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: const Text('Build Outfit'),
                      onPressed: () => context.push('/outfits/builder'),
                    ),
                  )
                : GridView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.78,
                    ),
                    itemCount: outfits.length,
                    itemBuilder: (_, i) => OutfitCard(
                      outfit: outfits[i],
                      index: i,
                      onTap: () => context.push('/outfits/${outfits[i].id}'),
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}

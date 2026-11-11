import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/providers.dart';
import '../../widgets/garment_card.dart';
import '../../widgets/category_filter.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../../core/constants/app_constants.dart';
import '../../../domain/models/garment.dart';
import '../../../l10n/catalog_labels.dart';
import '../../../l10n/generated/app_localizations.dart';

class ClosetScreen extends ConsumerWidget {
  const ClosetScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedCategory = ref.watch(closetCategoryProvider);
    final garmentsAsync = ref.watch(garmentsProvider(selectedCategory));

    final l10n = AppLocalizations.of(context);
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(context, ref),
            const SizedBox(height: 16),
            CategoryFilter(
              categories: AppConstants.garmentCategories,
              selected: selectedCategory,
              onSelected: (cat) =>
                  ref.read(closetCategoryProvider.notifier).state = cat,
            ),
            const SizedBox(height: 16),
            Expanded(
              child: garmentsAsync.when(
                loading: () => const GarmentGridShimmer(),
                error: (e, _) => ErrorView(
                  message: l10n.wardrobeFailed,
                  onRetry: () => ref.invalidate(garmentsProvider),
                ),
                data: (garments) => garments.isEmpty
                    ? EmptyView(
                        icon: Icons.checkroom_outlined,
                        title: selectedCategory == 'All'
                            ? l10n.closetEmpty
                            : l10n.categoryEmpty(
                                catalogLabel(l10n, selectedCategory),
                              ),
                        subtitle: selectedCategory == 'All'
                            ? l10n.closetEmptySubtitle
                            : l10n.categoryEmptySubtitle,
                        action: selectedCategory == 'All'
                            ? ElevatedButton.icon(
                                icon: const Icon(Icons.add),
                                label: Text(l10n.addGarment),
                                onPressed: () => context.push('/closet/add'),
                              )
                            : null,
                      )
                    : _buildGrid(context, garments),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.push('/closet/add'),
        child: const Icon(Icons.add),
      ).animate().scale(delay: 300.ms),
    );
  }

  Widget _buildHeader(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                AppLocalizations.of(context).myCloset,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              Consumer(
                builder: (_, ref, __) {
                  final category = ref.watch(closetCategoryProvider);
                  final count =
                      ref.watch(garmentsProvider(category)).valueOrNull?.length;
                  return Text(
                    count == null
                        ? ''
                        : AppLocalizations.of(context).itemCount(count),
                    style: Theme.of(context).textTheme.bodyMedium,
                  );
                },
              ),
            ],
          ),
          const Spacer(),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/closet/search'),
          ),
        ],
      ),
    );
  }

  Widget _buildGrid(BuildContext context, List<Garment> garments) {
    return GridView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 0.72,
      ),
      itemCount: garments.length,
      itemBuilder: (_, index) => GarmentCard(
        garment: garments[index],
        index: index,
        onTap: () => context.push('/closet/${garments[index].id}'),
      ),
    );
  }
}

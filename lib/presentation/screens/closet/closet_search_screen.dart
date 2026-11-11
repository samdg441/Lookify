import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/providers.dart';
import '../../widgets/garment_card.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../../domain/closet/garment_query.dart';

class ClosetSearchScreen extends ConsumerStatefulWidget {
  const ClosetSearchScreen({super.key});

  @override
  ConsumerState<ClosetSearchScreen> createState() => _ClosetSearchScreenState();
}

class _ClosetSearchScreenState extends ConsumerState<ClosetSearchScreen> {
  final _queryCtrl = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _queryCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final garmentsAsync = ref.watch(garmentsProvider(null));

    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _queryCtrl,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'Search name, brand, color',
            border: InputBorder.none,
          ),
          onChanged: (value) => setState(() => _query = value),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, size: 18),
          onPressed: () => context.pop(),
        ),
      ),
      body: garmentsAsync.when(
        loading: () => const LoadingIndicator(),
        error: (_, __) => ErrorView(
          message: 'Failed to search the wardrobe',
          onRetry: () => ref.invalidate(garmentsProvider),
        ),
        data: (garments) {
          final matches =
              garments.where((garment) => garmentMatchesQuery(garment, _query));
          if (matches.isEmpty) {
            return EmptyView(
              icon: Icons.search_off,
              title: _query.trim().isEmpty ? 'Nothing to search yet' : 'No matches',
              subtitle: _query.trim().isEmpty
                  ? 'Add a garment and search it by name, brand, or color'
                  : 'Try a different name, brand, or color',
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: matches.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, index) {
              final garment = matches.elementAt(index);
              return SizedBox(
                height: 220,
                child: GarmentCard(
                  garment: garment,
                  index: index,
                  onTap: () => context.push('/closet/${garment.id}'),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

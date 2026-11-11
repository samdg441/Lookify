import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/providers.dart';
import '../../widgets/garment_card.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../../domain/closet/garment_query.dart';
import '../../../l10n/generated/app_localizations.dart';

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

    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _queryCtrl,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: InputDecoration(
            hintText: l10n.searchHint,
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
          message: l10n.searchFailed,
          onRetry: () => ref.invalidate(garmentsProvider),
        ),
        data: (garments) {
          final matches =
              garments.where((garment) => garmentMatchesQuery(garment, _query));
          if (matches.isEmpty) {
            return EmptyView(
              icon: Icons.search_off,
              title: _query.trim().isEmpty ? l10n.nothingToSearch : l10n.noMatches,
              subtitle: _query.trim().isEmpty
                  ? l10n.nothingToSearchSubtitle
                  : l10n.noMatchesSubtitle,
              action: _query.trim().isEmpty
                  ? ElevatedButton.icon(
                      icon: const Icon(Icons.add),
                      label: Text(l10n.addGarment),
                      onPressed: () => context.push('/closet/add'),
                    )
                  : null,
            );
          }
          final results = matches.toList();
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.72,
            ),
            itemCount: results.length,
            itemBuilder: (_, index) => GarmentCard(
              garment: results[index],
              index: index,
              onTap: () => context.push('/closet/${results[index].id}'),
            ),
          );
        },
      ),
    );
  }
}

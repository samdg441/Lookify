import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/providers.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/outfit.dart';
import '../../../l10n/catalog_labels.dart';
import '../../../l10n/generated/app_localizations.dart';

class OutfitDetailScreen extends ConsumerWidget {
  const OutfitDetailScreen({super.key, required this.id});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final outfitAsync = ref.watch(outfitProvider(id));
    return outfitAsync.when(
      loading: () => const Scaffold(body: LoadingIndicator()),
      error: (_, __) => Scaffold(
        appBar: AppBar(),
        body: ErrorView(message: AppLocalizations.of(context).outfitNotFound),
      ),
      data: (outfit) => Scaffold(
        appBar: AppBar(
          title: Text(outfit.name),
          actions: [
            IconButton(
              icon: const Icon(Icons.edit_outlined),
              onPressed: () => _edit(context, ref, outfit),
            ),
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: () => _confirmDelete(context, ref),
            ),
          ],
        ),
        body: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            if (outfit.occasion != null || outfit.season != null)
              Text(
                [outfit.occasion, outfit.season]
                    .whereType<String>()
                    .map((value) => catalogLabel(AppLocalizations.of(context), value))
                    .join(' · '),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            const SizedBox(height: 8),
            Text(
              AppLocalizations.of(context).wornTimes(outfit.wearCount),
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 20),
            if (outfit.garments.isEmpty)
              Text(AppLocalizations.of(context).garmentsGone)
            else
              ...outfit.garments.map(
                (garment) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(garment.name),
                  subtitle: Text(
                    catalogLabel(AppLocalizations.of(context), garment.category),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/closet/${garment.id}'),
                ),
              ),
            if (outfit.notes != null) ...[
              const SizedBox(height: 12),
              Text(outfit.notes!, style: Theme.of(context).textTheme.bodyMedium),
            ],
            const SizedBox(height: 24),
            ElevatedButton.icon(
              icon: const Icon(Icons.checkroom),
              label: Text(AppLocalizations.of(context).logWornToday),
              onPressed: () async {
                await ref.read(outfitRepositoryProvider).incrementWearCount(id);
                ref.invalidate(outfitProvider(id));
                ref.invalidate(outfitsProvider);
                ref.invalidate(garmentsProvider);
                ref.invalidate(wardrobeInsightsProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(AppLocalizations.of(context).loggedWorn)),
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _edit(BuildContext context, WidgetRef ref, Outfit outfit) async {
    final nameCtrl = TextEditingController(text: outfit.name);
    var occasion = outfit.occasion;
    var season = outfit.season;
    final l10n = AppLocalizations.of(context);
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: Text(l10n.editOutfit),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(labelText: l10n.name),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: occasion,
                decoration: InputDecoration(labelText: l10n.occasion),
                items: [
                  for (final value in AppConstants.occasions)
                    DropdownMenuItem(
                      value: value,
                      child: Text(catalogLabel(l10n, value)),
                    ),
                ],
                onChanged: (value) => setState(() => occasion = value),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: season,
                decoration: InputDecoration(labelText: l10n.season),
                items: [
                  for (final value in AppConstants.seasons)
                    DropdownMenuItem(
                      value: value,
                      child: Text(catalogLabel(l10n, value)),
                    ),
                ],
                onChanged: (value) => setState(() => season = value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(l10n.cancel),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(l10n.save),
            ),
          ],
        ),
      ),
    );
    final name = nameCtrl.text.trim();
    nameCtrl.dispose();
    if (saved != true || name.isEmpty || !context.mounted) return;
    await ref.read(outfitRepositoryProvider).updateOutfit(
          id: id,
          name: name,
          occasion: occasion,
          season: season,
          notes: outfit.notes,
        );
    ref.invalidate(outfitProvider(id));
    ref.invalidate(outfitsProvider);
  }

  Future<void> _confirmDelete(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(l10n.deleteOutfit),
        content: Text(l10n.deleteOutfitBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: Text(l10n.delete, style: TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    await ref.read(outfitRepositoryProvider).deleteOutfit(id);
    ref.invalidate(outfitsProvider);
    ref.invalidate(calendarEntriesProvider);
    ref.invalidate(plannedOutfitsCountProvider);
    if (context.mounted) context.pop();
  }
}

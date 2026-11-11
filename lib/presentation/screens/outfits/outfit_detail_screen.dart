import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/providers.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/outfit.dart';

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
        body: const ErrorView(message: 'Outfit not found'),
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
                [outfit.occasion, outfit.season].whereType<String>().join(' · '),
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            const SizedBox(height: 8),
            Text(
              'Worn ${outfit.wearCount} times',
              style: Theme.of(context).textTheme.labelLarge,
            ),
            const SizedBox(height: 20),
            if (outfit.garments.isEmpty)
              const Text('The garments in this outfit are no longer in the closet')
            else
              ...outfit.garments.map(
                (garment) => ListTile(
                  contentPadding: EdgeInsets.zero,
                  title: Text(garment.name),
                  subtitle: Text(garment.category),
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
              label: const Text('Log as Worn Today'),
              onPressed: () async {
                await ref.read(outfitRepositoryProvider).incrementWearCount(id);
                ref.invalidate(outfitProvider(id));
                ref.invalidate(outfitsProvider);
                ref.invalidate(garmentsProvider);
                ref.invalidate(wardrobeInsightsProvider);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Logged as worn')),
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
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => StatefulBuilder(
        builder: (dialogContext, setState) => AlertDialog(
          backgroundColor: AppColors.surface,
          title: const Text('Edit Outfit'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: occasion,
                decoration: const InputDecoration(labelText: 'Occasion'),
                items: [
                  for (final value in AppConstants.occasions)
                    DropdownMenuItem(value: value, child: Text(value)),
                ],
                onChanged: (value) => setState(() => occasion = value),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                initialValue: season,
                decoration: const InputDecoration(labelText: 'Season'),
                items: [
                  for (final value in AppConstants.seasons)
                    DropdownMenuItem(value: value, child: Text(value)),
                ],
                onChanged: (value) => setState(() => season = value),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('Save'),
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
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: const Text('Delete Outfit'),
        content: const Text(
          'This outfit will be removed, including any days it is planned on.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Delete', style: TextStyle(color: AppColors.error)),
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

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../providers/providers.dart';
import '../../widgets/outfit_card.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';

class AiSuggestionsPanel extends ConsumerStatefulWidget {
  const AiSuggestionsPanel({super.key});

  @override
  ConsumerState<AiSuggestionsPanel> createState() => _AiSuggestionsPanelState();
}

class _AiSuggestionsPanelState extends ConsumerState<AiSuggestionsPanel> {
  String? _occasion;
  String? _season;
  String? _weather;

  @override
  Widget build(BuildContext context) {
    final params = SuggestionRequest(
      occasion: _occasion,
      season: _season,
      weather: _weather,
    );
    final suggestionsAsync = ref.watch(aiSuggestionsProvider(params));

    return Column(
      children: [
        const SizedBox(height: 12),
        _buildFilters(),
        const SizedBox(height: 12),
        Expanded(
          child: suggestionsAsync.when(
            loading: () => Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircularProgressIndicator(color: AppColors.primary),
                const SizedBox(height: 16),
                Text(
                  'Curating your perfect outfits…',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            error: (_, __) => ErrorView(
              message: 'Could not generate suggestions.\nTry again in a moment.',
              onRetry: () => ref.invalidate(aiSuggestionsProvider(params)),
            ),
            data: (suggestions) => suggestions.isEmpty
                ? const EmptyView(
                    icon: Icons.auto_awesome_outlined,
                    title: 'No suggestions yet',
                    subtitle:
                        'Add garments to your closet\nto get AI outfit recommendations',
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    itemCount: suggestions.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final suggestion = suggestions[i];
                      return OutfitSuggestionCard(
                        name: suggestion.name,
                        description: suggestion.description,
                        occasion: suggestion.occasion,
                        tip: suggestion.tip,
                        garmentCount: suggestion.garments.length,
                        index: i,
                        onSave: () => _saveOutfit(
                          suggestion.name,
                          suggestion.garments.map((garment) => garment.id).toList(),
                          suggestion.occasion,
                        ),
                      );
                    },
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildFilters() {
    final hasFilter =
        _occasion != null || _season != null || _weather != null;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          _filterChip('Occasion', _occasion, AppConstants.occasions, (value) {
            setState(() => _occasion = value);
          }),
          const SizedBox(width: 8),
          _filterChip('Season', _season, AppConstants.seasons, (value) {
            setState(() => _season = value);
          }),
          const SizedBox(width: 8),
          _filterChip('Weather', _weather, AppConstants.weatherOptions, (value) {
            setState(() => _weather = value);
          }),
          if (hasFilter) ...[
            const SizedBox(width: 8),
            GestureDetector(
              onTap: () => setState(() {
                _occasion = null;
                _season = null;
                _weather = null;
              }),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: AppColors.error.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Clear',
                  style: TextStyle(color: AppColors.error, fontSize: 13),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _filterChip(
    String label,
    String? selected,
    List<String> options,
    ValueChanged<String?> onChanged,
  ) {
    return GestureDetector(
      onTap: () => _showFilterSheet(label, options, selected, onChanged),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: selected != null
              ? AppColors.primary.withOpacity(0.15)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected != null ? AppColors.primary : AppColors.border,
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              selected ?? label,
              style: TextStyle(
                color: selected != null
                    ? AppColors.primary
                    : AppColors.textSecondary,
                fontSize: 13,
                fontWeight:
                    selected != null ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
            const SizedBox(width: 4),
            Icon(
              Icons.keyboard_arrow_down,
              size: 16,
              color: selected != null
                  ? AppColors.primary
                  : AppColors.textDisabled,
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterSheet(
    String label,
    List<String> options,
    String? selected,
    ValueChanged<String?> onChanged,
  ) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 8),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.border,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Text(label, style: Theme.of(context).textTheme.titleMedium),
            ),
            ...options.map(
              (option) => ListTile(
                title: Text(option),
                trailing: selected == option
                    ? const Icon(Icons.check, color: AppColors.primary)
                    : null,
                onTap: () {
                  onChanged(selected == option ? null : option);
                  context.pop();
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Future<void> _saveOutfit(
    String name,
    List<String> garmentIds,
    String occasion,
  ) async {
    try {
      await ref.read(outfitRepositoryProvider).createOutfit(
            name: name,
            garmentIds: garmentIds,
            occasion: occasion,
            season: _season,
          );
      ref.invalidate(outfitsProvider);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Outfit saved')),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not save the outfit: $error')),
        );
      }
    }
  }
}

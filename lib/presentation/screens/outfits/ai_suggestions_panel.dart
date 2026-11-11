import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../providers/providers.dart';
import '../../widgets/option_sheet.dart';
import '../../widgets/outfit_card.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../l10n/catalog_labels.dart';
import '../../../l10n/generated/app_localizations.dart';

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
                  AppLocalizations.of(context).curating,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            error: (_, __) => ErrorView(
              message: AppLocalizations.of(context).suggestionsFailed,
              onRetry: () => ref.invalidate(aiSuggestionsProvider(params)),
            ),
            data: (suggestions) => suggestions.isEmpty
                ? EmptyView(
                    icon: Icons.auto_awesome_outlined,
                    title: AppLocalizations.of(context).noSuggestions,
                    subtitle: AppLocalizations.of(context).noSuggestionsSubtitle,
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
          _filterChip(AppLocalizations.of(context).occasion, _occasion, AppConstants.occasions, (value) {
            setState(() => _occasion = value);
          }),
          const SizedBox(width: 8),
          _filterChip(AppLocalizations.of(context).season, _season, AppConstants.seasons, (value) {
            setState(() => _season = value);
          }),
          const SizedBox(width: 8),
          _filterChip(AppLocalizations.of(context).weather, _weather, AppConstants.weatherOptions, (value) {
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
                child: Text(
                  AppLocalizations.of(context).clear,
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
      onTap: () => showOptionSheet(
        context: context,
        label: label,
        options: options,
        selected: selected,
        onChanged: onChanged,
      ),
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
              selected == null
                  ? label
                  : catalogLabel(AppLocalizations.of(context), selected),
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
          SnackBar(content: Text(AppLocalizations.of(context).outfitSaved)),
        );
      }
    } catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).couldNotSaveOutfit('$error')),
          ),
        );
      }
    }
  }
}

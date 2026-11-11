import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/providers.dart';
import '../../widgets/garment_card.dart';
import '../../widgets/option_sheet.dart';
import '../../widgets/category_filter.dart';
import '../../widgets/common/loading_indicator.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/models/garment.dart';
import '../../../l10n/catalog_labels.dart';
import '../../../l10n/generated/app_localizations.dart';

class OutfitBuilderScreen extends ConsumerStatefulWidget {
  const OutfitBuilderScreen({super.key});

  @override
  ConsumerState<OutfitBuilderScreen> createState() =>
      _OutfitBuilderScreenState();
}

class _OutfitBuilderScreenState extends ConsumerState<OutfitBuilderScreen> {
  final _nameCtrl = TextEditingController();
  final Set<String> _selectedIds = {};
  String? _occasion;
  String? _season;
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    super.dispose();
  }

  List<Garment> _selectedGarments(List<Garment> all) =>
      all.where((g) => _selectedIds.contains(g.id)).toList();

  Future<void> _save(List<Garment> all) async {
    if (_nameCtrl.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).outfitNameRequired)),
      );
      return;
    }
    if (_selectedIds.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context).selectGarment)),
      );
      return;
    }
    setState(() => _saving = true);
    try {
      await ref.read(outfitRepositoryProvider).createOutfit(
            name: _nameCtrl.text.trim(),
            garmentIds: _selectedIds.toList(),
            occasion: _occasion,
            season: _season,
          );
      ref.invalidate(outfitsProvider);
      if (mounted) context.pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(
              content: Text(AppLocalizations.of(context).couldNotSaveOutfit('$e')),
            ));
      }
    } finally {
      if (mounted) setState(() => _saving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final category = ref.watch(builderCategoryProvider);
    final garmentsAsync = ref.watch(garmentsProvider(category));

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).buildOutfit),
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        actions: [
          garmentsAsync.when(
            data: (garments) => TextButton(
              onPressed: _saving ? null : () => _save(garments),
              child: _saving
                  ? SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppColors.primary,
                      ),
                    )
                  : Text(AppLocalizations.of(context).save),
            ),
            loading: () => const SizedBox.shrink(),
            error: (_, __) => const SizedBox.shrink(),
          ),
        ],
      ),
      body: Column(
        children: [
          _buildTopSection(),
          const SizedBox(height: 4),
          CategoryFilter(
            categories: AppConstants.garmentCategories,
            selected: category,
            onSelected: (c) =>
                ref.read(builderCategoryProvider.notifier).state = c,
          ),
          const SizedBox(height: 12),
          if (_selectedIds.isNotEmpty)
            garmentsAsync.when(
              data: (garments) =>
                  _buildSelectedPreview(_selectedGarments(garments)),
              loading: () => const SizedBox.shrink(),
              error: (_, __) => const SizedBox.shrink(),
            ),
          Expanded(
            child: garmentsAsync.when(
              loading: () => const GarmentGridShimmer(),
              error: (e, _) => ErrorView(message: AppLocalizations.of(context).garmentsFailed),
              data: (garments) => garments.isEmpty
                  ? EmptyView(
                      icon: Icons.checkroom_outlined,
                      title: AppLocalizations.of(context).noGarmentsYet,
                      subtitle: AppLocalizations.of(context).noGarmentsSubtitle,
                    )
                  : GridView.builder(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 8,
                        mainAxisSpacing: 8,
                        childAspectRatio: 0.75,
                      ),
                      itemCount: garments.length,
                      itemBuilder: (_, i) => GarmentCard(
                        garment: garments[i],
                        index: i,
                        selected: _selectedIds.contains(garments[i].id),
                        onTap: () => setState(() {
                          if (_selectedIds.contains(garments[i].id)) {
                            _selectedIds.remove(garments[i].id);
                          } else {
                            _selectedIds.add(garments[i].id);
                          }
                        }),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTopSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _nameCtrl,
            textCapitalization: TextCapitalization.sentences,
            decoration: InputDecoration(
              hintText: AppLocalizations.of(context).outfitNameHint,
              prefixIcon: const Icon(Icons.edit_outlined),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: _dropdownChip(
                  AppLocalizations.of(context).occasion,
                  _occasion,
                  AppConstants.occasions,
                  (v) => setState(() => _occasion = v),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _dropdownChip(
                  AppLocalizations.of(context).season,
                  _season,
                  AppConstants.seasons,
                  (v) => setState(() => _season = v),
                ),
              ),
            ],
          ),
        ],
      ),
    ).animate().fadeIn();
  }

  Widget _dropdownChip(String label, String? selected, List<String> options,
      ValueChanged<String?> onChanged) {
    return GestureDetector(
      onTap: () => showOptionSheet(
        context: context,
        label: label,
        options: options,
        selected: selected,
        onChanged: onChanged,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: selected != null
              ? AppColors.primary.withOpacity(0.12)
              : AppColors.surfaceVariant,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected != null ? AppColors.primary : AppColors.border,
            width: 0.5,
          ),
        ),
        child: Row(
          children: [
            Expanded(
              child: Text(
                selected == null
                    ? label
                    : catalogLabel(AppLocalizations.of(context), selected),
                style: TextStyle(
                  color: selected != null
                      ? AppColors.primary
                      : AppColors.textDisabled,
                  fontSize: 13,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Icon(Icons.keyboard_arrow_down,
                size: 16, color: AppColors.textDisabled),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedPreview(List<Garment> selected) {
    return Container(
      height: 72,
      margin: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 52,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: selected.length,
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    selected[i].name.split(' ').first,
                    style: TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w500),
                  ),
                ),
              ),
            ),
          ),
          Text(
            AppLocalizations.of(context).selectedCount(selected.length),
            style: TextStyle(
                color: AppColors.primary,
                fontSize: 12,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    ).animate().fadeIn().slideY(begin: -0.1);
  }
}

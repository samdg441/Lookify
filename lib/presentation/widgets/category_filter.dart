import 'package:flutter/material.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/helpers.dart';
import '../../l10n/catalog_labels.dart';
import '../../l10n/generated/app_localizations.dart';

class CategoryFilter extends StatelessWidget {
  const CategoryFilter({
    super.key,
    required this.categories,
    required this.selected,
    required this.onSelected,
    this.showAll = true,
    this.showIcons = true,
  });

  final List<String> categories;
  final String selected;
  final ValueChanged<String> onSelected;
  final bool showAll;
  final bool showIcons;

  @override
  Widget build(BuildContext context) {
    final items = showAll ? ['All', ...categories] : categories;
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: items.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final cat = items[index];
          final isSelected = cat == selected;
          return GestureDetector(
            onTap: () => onSelected(cat),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: isSelected
                    ? AppColors.primary
                    : AppColors.surfaceVariant,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected ? AppColors.primary : AppColors.border,
                  width: 0.5,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (showIcons && cat != 'All') ...[
                    Text(
                      categoryIcon(cat),
                      style: const TextStyle(fontSize: 13),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    cat == 'All'
                        ? AppLocalizations.of(context).all
                        : catalogLabel(AppLocalizations.of(context), cat),
                    style: TextStyle(
                      color: isSelected
                          ? AppColors.onPrimary
                          : AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../l10n/catalog_labels.dart';
import '../../l10n/generated/app_localizations.dart';

/// Picks one value from [options]. Tapping the current value clears it.
Future<void> showOptionSheet({
  required BuildContext context,
  required String label,
  required List<String> options,
  required String? selected,
  required ValueChanged<String?> onChanged,
}) {
  return showModalBottomSheet<void>(
    context: context,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
    ),
    builder: (sheetContext) => SafeArea(
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
            child: Text(
              label,
              style: Theme.of(sheetContext).textTheme.titleMedium,
            ),
          ),
          for (final option in options)
            ListTile(
              title: Text(
                catalogLabel(AppLocalizations.of(sheetContext), option),
              ),
              trailing: selected == option
                  ? Icon(Icons.check, color: AppColors.primary)
                  : null,
              onTap: () {
                onChanged(selected == option ? null : option);
                Navigator.pop(sheetContext);
              },
            ),
          const SizedBox(height: 8),
        ],
      ),
    ),
  );
}

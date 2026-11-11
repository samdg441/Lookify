import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../providers/locale_controller.dart';
import '../../providers/providers.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/auth/auth_session.dart';
import '../../../domain/auth/credential_rules.dart';
import '../../../l10n/catalog_labels.dart';
import '../../../l10n/generated/app_localizations.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);

    final l10n = AppLocalizations.of(context);
    final locale = ref.watch(localeProvider);
    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            _buildAvatar(context, user).animate().fadeIn(),
            const SizedBox(height: 32),
            _buildSection(
              context,
              title: l10n.preferences,
              children: [
                _tile(
                  context,
                  icon: Icons.language_outlined,
                  label: l10n.language,
                  trailing: Text(
                    locale.languageCode == 'en' ? l10n.english : l10n.spanish,
                    style: const TextStyle(
                      color: AppColors.textDisabled,
                      fontSize: 13,
                    ),
                  ),
                  onTap: () => _chooseLanguage(context, ref),
                ),
              ],
            ).animate().fadeIn(delay: 50.ms),
            const SizedBox(height: 20),
            _buildSection(
              context,
              title: l10n.account,
              children: [
                _tile(context,
                    icon: Icons.person_outline,
                    label: l10n.editName,
                    onTap: () => _editName(context, ref, user)),
                _tile(context,
                    icon: Icons.lock_reset,
                    label: l10n.resetPassword,
                    onTap: () => _sendReset(context, ref, user?.email)),
                _tile(context,
                    icon: Icons.delete_outline,
                    label: l10n.deleteAccount,
                    onTap: () => _deleteAccount(context, ref)),
              ],
            ).animate().fadeIn(delay: 100.ms),
            const SizedBox(height: 20),
            _buildSection(
              context,
              title: l10n.about,
              children: [
                _tile(
                  context,
                  icon: Icons.info_outline,
                  label: l10n.appVersion,
                  trailing: const Text(
                    '1.0.0',
                    style: TextStyle(color: AppColors.textDisabled, fontSize: 13),
                  ),
                  onTap: () {},
                ),
              ],
            ).animate().fadeIn(delay: 150.ms),
            const SizedBox(height: 32),
            OutlinedButton.icon(
              icon: const Icon(Icons.logout, color: AppColors.error),
              label: Text(l10n.signOut,
                  style: const TextStyle(color: AppColors.error)),
              style: OutlinedButton.styleFrom(
                side: const BorderSide(color: AppColors.error),
              ),
              onPressed: () => _confirmSignOut(context, ref),
            ).animate().fadeIn(delay: 250.ms),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar(BuildContext context, AuthSession? user) {
    final rawName = user?.displayName?.trim();
    final name = (rawName == null || rawName.isEmpty)
        ? AppLocalizations.of(context).defaultUserName
        : rawName;
    final email = user?.email ?? '';
    final initials = name
        .trim()
        .split(' ')
        .where((word) => word.isNotEmpty)
        .take(2)
        .map((word) => word[0])
        .join();

    return Row(
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.15),
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.primary.withOpacity(0.3)),
          ),
          child: Center(
            child: Text(
              initials.toUpperCase(),
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 26,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 2),
              Text(email, style: Theme.of(context).textTheme.bodySmall),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title, required List<Widget> children}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 10),
          child: Text(title, style: Theme.of(context).textTheme.labelLarge),
        ),
        Material(
          color: AppColors.card,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
            side: const BorderSide(color: AppColors.border, width: 0.5),
          ),
          clipBehavior: Clip.antiAlias,
          child: Column(children: children),
        ),
      ],
    );
  }

  Widget _tile(BuildContext context,
      {required IconData icon,
      required String label,
      Widget? trailing,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: AppColors.textSecondary, size: 20),
      title: Text(label, style: Theme.of(context).textTheme.bodyLarge),
      trailing: trailing ?? const Icon(Icons.chevron_right, color: AppColors.textDisabled, size: 18),
      onTap: onTap,
      minLeadingWidth: 20,
    );
  }

  Future<void> _chooseLanguage(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context);
    final selected = await showDialog<Locale>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(l10n.language),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: Text(l10n.spanish),
              onTap: () => Navigator.pop(dialogContext, const Locale('es')),
            ),
            ListTile(
              title: Text(l10n.english),
              onTap: () => Navigator.pop(dialogContext, const Locale('en')),
            ),
          ],
        ),
      ),
    );
    if (selected != null) {
      await ref.read(localeProvider.notifier).setLocale(selected);
    }
  }

  Future<void> _editName(
    BuildContext context,
    WidgetRef ref,
    AuthSession? user,
  ) async {
    final controller = TextEditingController(text: user?.displayName ?? '');
    final l10n = AppLocalizations.of(context);
    final saved = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(l10n.editName),
        content: TextField(
          controller: controller,
          textCapitalization: TextCapitalization.words,
          decoration: InputDecoration(labelText: l10n.fullName),
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
    );
    final name = controller.text.trim();
    controller.dispose();
    if (saved != true || !context.mounted) return;
    final error = CredentialRules.fullName(name);
    if (error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(localizeError(AppLocalizations.of(context), error)),
        ),
      );
      return;
    }
    try {
      await ref.read(authGatewayProvider).updateProfile(fullName: name);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).nameUpdated)),
        );
      }
    } on AuthFailure catch (failure) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizeError(AppLocalizations.of(context), failure.message),
            ),
          ),
        );
      }
    }
  }

  Future<void> _sendReset(
    BuildContext context,
    WidgetRef ref,
    String? email,
  ) async {
    if (email == null || email.isEmpty) return;
    try {
      await ref.read(authGatewayProvider).sendPasswordReset(email);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(AppLocalizations.of(context).resetEmailSent)),
        );
      }
    } on AuthFailure catch (failure) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizeError(AppLocalizations.of(context), failure.message),
            ),
          ),
        );
      }
    }
  }

  Future<void> _deleteAccount(BuildContext context, WidgetRef ref) async {
    final passwordCtrl = TextEditingController();
    final l10n = AppLocalizations.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(l10n.deleteAccount),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(l10n.deleteAccountBody),
            const SizedBox(height: 12),
            TextField(
              controller: passwordCtrl,
              obscureText: true,
              decoration: InputDecoration(labelText: l10n.password),
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
            child: Text(l10n.delete, style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
    final password = passwordCtrl.text;
    passwordCtrl.dispose();
    if (confirmed != true || !context.mounted) return;
    try {
      await ref.read(closeAccountProvider).call(password: password);
      if (context.mounted) context.go('/login');
    } on AuthFailure catch (failure) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizeError(AppLocalizations.of(context), failure.message),
            ),
          ),
        );
      }
    }
  }

  void _confirmSignOut(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: AppColors.surface,
        title: Text(l10n.signOutTitle),
        content: Text(l10n.signOutBody),
        actions: [
          TextButton(
            onPressed: () => context.pop(),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              context.pop();
              await ref.read(authGatewayProvider).signOut();
              if (context.mounted) context.go('/login');
            },
            child: Text(l10n.signOut,
                style: const TextStyle(color: AppColors.error)),
          ),
        ],
      ),
    );
  }
}

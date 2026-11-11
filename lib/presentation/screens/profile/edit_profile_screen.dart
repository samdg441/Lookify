import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/auth/auth_session.dart';
import '../../../domain/auth/credential_rules.dart';
import '../../providers/providers.dart';

class EditProfileScreen extends ConsumerStatefulWidget {
  const EditProfileScreen({super.key});

  @override
  ConsumerState<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends ConsumerState<EditProfileScreen> {
  final _nameFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  late final TextEditingController _nameCtrl;
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;
  bool _savingName = false;
  bool _savingPassword = false;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(
      text: ref.read(currentUserProvider)?.displayName ?? '',
    );
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  void _toast(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  Future<void> _saveName() async {
    if (!_nameFormKey.currentState!.validate()) return;
    setState(() => _savingName = true);
    try {
      await ref.read(authGatewayProvider).updateDisplayName(_nameCtrl.text);
      _toast('Name updated');
    } on AuthFailure catch (error) {
      _toast(error.message);
    } catch (error, stackTrace) {
      await ref.read(crashReporterProvider).record(
            error,
            stackTrace,
            reason: 'Unexpected name update failure',
          );
      _toast('Could not update your name');
    } finally {
      if (mounted) setState(() => _savingName = false);
    }
  }

  Future<void> _savePassword() async {
    if (!_passwordFormKey.currentState!.validate()) return;
    setState(() => _savingPassword = true);
    try {
      await ref.read(authGatewayProvider).changePassword(
            currentPassword: _currentCtrl.text,
            newPassword: _newCtrl.text,
          );
      _currentCtrl.clear();
      _newCtrl.clear();
      _confirmCtrl.clear();
      _toast('Password updated');
    } on AuthFailure catch (error) {
      _toast(error.message);
    } catch (error, stackTrace) {
      await ref.read(crashReporterProvider).record(
            error,
            stackTrace,
            reason: 'Unexpected password change failure',
          );
      _toast('Could not update your password');
    } finally {
      if (mounted) setState(() => _savingPassword = false);
    }
  }

  Widget _passwordField(
    TextEditingController controller,
    String label,
    String? Function(String?) validator,
  ) {
    return TextFormField(
      controller: controller,
      obscureText: _obscure,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon:
            Icon(Icons.lock_outline, color: AppColors.textDisabled),
        suffixIcon: IconButton(
          icon: Icon(
            _obscure
                ? Icons.visibility_off_outlined
                : Icons.visibility_outlined,
            color: AppColors.textDisabled,
          ),
          onPressed: () => setState(() => _obscure = !_obscure),
        ),
      ),
      validator: validator,
    );
  }

  Widget _spinner() => SizedBox(
        height: 20,
        width: 20,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: AppColors.onPrimary,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.pop(),
        ),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Text('Name', style: textTheme.titleMedium),
            const SizedBox(height: 12),
            Form(
              key: _nameFormKey,
              child: TextFormField(
                controller: _nameCtrl,
                textCapitalization: TextCapitalization.words,
                decoration: InputDecoration(
                  labelText: 'Full Name',
                  prefixIcon: Icon(Icons.person_outline,
                      color: AppColors.textDisabled),
                ),
                validator: CredentialRules.fullName,
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _savingName ? null : _saveName,
              child: _savingName ? _spinner() : const Text('Save name'),
            ),
            const SizedBox(height: 36),
            Text('Password', style: textTheme.titleMedium),
            const SizedBox(height: 12),
            Form(
              key: _passwordFormKey,
              child: Column(
                children: [
                  _passwordField(
                    _currentCtrl,
                    'Current password',
                    (v) => (v == null || v.isEmpty)
                        ? 'Enter your current password'
                        : null,
                  ),
                  const SizedBox(height: 16),
                  _passwordField(
                    _newCtrl,
                    'New password',
                    CredentialRules.password,
                  ),
                  const SizedBox(height: 16),
                  _passwordField(
                    _confirmCtrl,
                    'Confirm new password',
                    (v) => v != _newCtrl.text ? 'Passwords do not match' : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: _savingPassword ? null : _savePassword,
              child: _savingPassword ? _spinner() : const Text('Change password'),
            ),
          ],
        ),
      ),
    );
  }
}

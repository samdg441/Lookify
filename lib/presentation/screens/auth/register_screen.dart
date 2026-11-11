import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../core/theme/app_colors.dart';
import '../../../domain/auth/auth_session.dart';
import '../../../domain/auth/credential_rules.dart';
import '../../../l10n/catalog_labels.dart';
import '../../../l10n/generated/app_localizations.dart';
import '../../providers/providers.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  bool _obscurePassword = true;
  bool _loading = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  String? _errorText(String? code) {
    if (code == null) return null;
    return localizeError(AppLocalizations.of(context), code);
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    try {
      await ref.read(authGatewayProvider).register(
            fullName: _nameCtrl.text,
            email: _emailCtrl.text,
            password: _passwordCtrl.text,
          );
      if (!mounted) return;
      context.go('/home');
    } on AuthFailure catch (error) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              localizeError(AppLocalizations.of(context), error.message),
            ),
          ),
        );
      }
    } catch (error, stackTrace) {
      await ref.read(crashReporterProvider).record(
            error,
            stackTrace,
            reason: 'Unexpected registration failure',
          );
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).couldNotCreateAccount),
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context).createAccount,
                  style: Theme.of(context).textTheme.headlineMedium,
                ).animate().fadeIn().slideX(begin: -0.1),
                const SizedBox(height: 8),
                Text(
                  AppLocalizations.of(context).createAccountSubtitle,
                  style: Theme.of(context).textTheme.bodyMedium,
                ).animate().fadeIn(delay: 100.ms),
                const SizedBox(height: 40),
                TextFormField(
                  controller: _nameCtrl,
                  textCapitalization: TextCapitalization.words,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).fullName,
                    prefixIcon:
                        Icon(Icons.person_outline, color: AppColors.textDisabled),
                  ),
                  validator: (value) => _errorText(CredentialRules.fullName(value)),
                ).animate().fadeIn(delay: 150.ms).slideY(begin: 0.1),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).email,
                    prefixIcon:
                        Icon(Icons.mail_outline, color: AppColors.textDisabled),
                  ),
                  validator: (value) => _errorText(CredentialRules.email(value)),
                ).animate().fadeIn(delay: 200.ms).slideY(begin: 0.1),
                const SizedBox(height: 16),
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: _obscurePassword,
                  decoration: InputDecoration(
                    labelText: AppLocalizations.of(context).password,
                    prefixIcon: Icon(Icons.lock_outline,
                        color: AppColors.textDisabled),
                    suffixIcon: IconButton(
                      icon: Icon(
                        _obscurePassword
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        color: AppColors.textDisabled,
                      ),
                      onPressed: () =>
                          setState(() => _obscurePassword = !_obscurePassword),
                    ),
                  ),
                  validator: (value) => _errorText(CredentialRules.password(value)),
                ).animate().fadeIn(delay: 250.ms).slideY(begin: 0.1),
                const SizedBox(height: 32),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _register,
                    child: _loading
                        ? SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: AppColors.onPrimary,
                            ),
                          )
                        : Text(AppLocalizations.of(context).createAccount),
                  ),
                ).animate().fadeIn(delay: 300.ms),
                const SizedBox(height: 24),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context).alreadyHaveAccount,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      GestureDetector(
                        onTap: () => context.go('/login'),
                        child: Text(
                          AppLocalizations.of(context).signIn,
                          style: GoogleFonts.inter(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(delay: 350.ms),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

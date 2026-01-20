import 'package:amazing_icons/amazing_icons.dart' show AmazingIconFilled;
import 'package:amazing_icons/outlined.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/design/animation/animated_icon_switcher.dart';
import 'package:storyzz/core/design/insets.dart';
import 'package:storyzz/core/design/theme.dart';
import 'package:storyzz/core/design/widgets/language_selector.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/auth_provider.dart';
import 'package:storyzz/core/providers/settings_provider.dart';
import 'package:storyzz/core/utils/constants.dart';
import 'package:storyzz/features/auth/presentation/widgets/auth_action_button.dart';
import 'package:storyzz/features/auth/presentation/widgets/auth_bottom_link.dart';
import 'package:storyzz/features/auth/presentation/widgets/auth_form_container.dart';
import 'package:storyzz/features/auth/presentation/widgets/auth_screen_wrapper.dart';

/// A screen that allows the user to log in to their existing account. It contains fields
/// for the user's email and password, along with validation for each field.
///
/// The user can submit the login form by pressing the "Login" button, which triggers
/// the login process through an authentication provider.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      final authProvider = context.read<AuthProvider>();

      final result = await authProvider.loginNetwork(
        _emailController.text,
        _passwordController.text,
      );

      if (!mounted) return;

      // Clear success path
      if (result.data != null && !result.data!.error) {
        context.read<AuthProvider>().isLogged();
        _showSuccessSnackbar();
        return;
      }

      final errorMessage =
          result.message ??
          result.data?.message ??
          AppLocalizations.of(context)!.login_failed;
      _showErrorSnackbar(errorMessage);
    }
  }

  void _showSuccessSnackbar() {
    double screenWidth = MediaQuery.of(context).size.width;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        margin: _getSnackbarMargin(screenWidth),
        content: Text(AppLocalizations.of(context)!.login_succes),
      ),
    );
  }

  void _showErrorSnackbar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        width: 500,
        behavior: SnackBarBehavior.floating,
        content: Text(message),
        backgroundColor: Theme.of(context).colorScheme.error,
      ),
    );
  }

  EdgeInsets _getSnackbarMargin(double screenWidth) {
    return switch (screenWidth) {
      < mobileBreakpoint => EdgeInsets.only(bottom: 16, left: 16, right: 16),
      >= tabletBreakpoint => EdgeInsets.only(
        bottom: 16,
        left: 306 + 16,
        right: 16,
      ),
      _ => EdgeInsets.only(bottom: 16, left: 96, right: 16),
    };
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            actions: [
              Consumer<SettingsProvider>(
                builder: (context, provider, _) => Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Opacity(
                    opacity: authProvider.isLoadingLogin ? 0.4 : 1.0,
                    child: IgnorePointer(
                      ignoring: authProvider.isLoadingLogin,
                      child: LanguageSelector(
                        currentLanguageCode: provider.locale.languageCode,
                        isCompact: true,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: AuthScreenWrapper(
            child: AuthFormContainer(
              formKey: _formKey,
              title: localizations.welcome_back,
              subtitle: localizations.sign_in_to_continue,
              isLoading: authProvider.isLoadingLogin,
              fields: [
                // Email Field
                Semantics(
                  label: localizations.email_form,
                  textField: true,
                  child: TextFormField(
                    enabled: !authProvider.isLoadingLogin,
                    controller: _emailController,
                    decoration: customInputDecoration(
                      label: localizations.email,
                      prefixIcon: AmazingIconOutlined.email,
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations.enter_email;
                      }
                      if (!RegExp(
                        r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                      ).hasMatch(value)) {
                        return localizations.enter_valid_email;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 16),

                // Password Field
                Semantics(
                  label: localizations.password_form,
                  textField: true,
                  child: TextFormField(
                    enabled: !authProvider.isLoadingLogin,
                    controller: _passwordController,
                    decoration: customInputDecoration(
                      label: localizations.password,
                      prefixIcon: AmazingIconOutlined.lock,
                      suffixIcon: IconButton(
                        icon: AnimatedIconSwitcher(
                          icon: _obscurePassword
                              ? AmazingIconFilled.eyeSlash
                              : AmazingIconFilled.eye,
                          valueKey: _obscurePassword,
                          size: 26,
                        ),
                        onPressed: () {
                          setState(() => _obscurePassword = !_obscurePassword);
                        },
                      ),
                    ),
                    obscureText: _obscurePassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations.enter_password;
                      }
                      if (value.length < 8) {
                        return localizations.password_minimum;
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 8),

                // Forgot Password Link
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: authProvider.isLoadingLogin
                        ? null
                        : () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(localizations.only_for_ui),
                              ),
                            );
                          },
                    style: TextButton.styleFrom(
                      padding: Insets.h8,
                      minimumSize: const Size(50, 30),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(localizations.forgot_password),
                  ),
                ),
              ],
              actionButton: AuthActionButton(
                text: localizations.login_upper,
                isLoading: authProvider.isLoadingLogin,
                onPressed: _handleLogin,
              ),
              bottomLink: AuthBottomLink(
                text: localizations.dont_have_account,
                linkText: localizations.register_lower,
                onPressed: !authProvider.isLoadingLogin
                    ? () => context.go('/register')
                    : null,
              ),
            ),
          ),
        );
      },
    );
  }
}

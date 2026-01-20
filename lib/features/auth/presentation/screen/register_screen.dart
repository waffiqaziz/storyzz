import 'package:amazing_icons/amazing_icons.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/models/user.dart';
import 'package:storyzz/core/design/animation/animated_icon_switcher.dart';
import 'package:storyzz/core/design/theme.dart';
import 'package:storyzz/core/design/widgets/language_selector.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/auth_provider.dart';
import 'package:storyzz/core/providers/settings_provider.dart';
import 'package:storyzz/features/auth/presentation/widgets/auth_action_button.dart';
import 'package:storyzz/features/auth/presentation/widgets/auth_bottom_link.dart';
import 'package:storyzz/features/auth/presentation/widgets/auth_form_container.dart';
import 'package:storyzz/features/auth/presentation/widgets/auth_screen_wrapper.dart';

/// A screen that allows the user to register a new account. It contains fields
/// for the user's name, email, password, and confirm password, along with
/// validation for each field.
///
/// The user can submit the registration form by pressing the "Register" button,
/// which triggers the registration process through an authentication provider.
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus(); // close virtual keyboard
      final authProvider = context.read<AuthProvider>();
      final User user = User(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      final result = await authProvider.register(user);
      if (result.data != null && !result.data!.error) {
        if (mounted) {
          context.go('/login');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(AppLocalizations.of(context)!.register_success),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              content: Text(
                result.message ??
                    result.data?.message ??
                    AppLocalizations.of(context)!.register_failed,
                style: TextStyle(color: Colors.black),
              ),
              backgroundColor: Theme.of(context).colorScheme.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final localizations = AppLocalizations.of(context)!;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) context.go('/login');
      },
      child: Consumer<AuthProvider>(
        builder: (context, authProvider, _) {
          return Scaffold(
            extendBodyBehindAppBar: true,
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              actions: [
                Consumer<SettingsProvider>(
                  builder: (context, provider, _) => Padding(
                    padding: const EdgeInsets.only(right: 8.0),
                    child: Opacity(
                      opacity: authProvider.isLoadingRegister ? 0.4 : 1.0,
                      child: IgnorePointer(
                        ignoring: authProvider.isLoadingRegister,
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
                title: localizations.create_account,
                subtitle: localizations.sign_up_to_get_started,
                isLoading: authProvider.isLoadingRegister,
                fields: [
                  // name field
                  TextFormField(
                    enabled: !authProvider.isLoadingRegister,
                    controller: _nameController,
                    decoration: customInputDecoration(
                      label: localizations.full_name,
                      prefixIcon: AmazingIconOutlined.user,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations.enter_full_name;
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // email Field
                  TextFormField(
                    enabled: !authProvider.isLoadingRegister,
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
                  const SizedBox(height: 16),

                  // password field
                  TextFormField(
                    enabled: !authProvider.isLoadingRegister,
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
                          setState(() {
                            _obscurePassword = !_obscurePassword;
                          });
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
                  const SizedBox(height: 16),

                  // confirm password field
                  TextFormField(
                    enabled: !authProvider.isLoadingRegister,
                    controller: _confirmPasswordController,
                    decoration: customInputDecoration(
                      label: localizations.confirm_password,
                      prefixIcon: AmazingIconOutlined.lock,
                      suffixIcon: IconButton(
                        icon: AnimatedIconSwitcher(
                          icon: _obscureConfirmPassword
                              ? AmazingIconFilled.eyeSlash
                              : AmazingIconFilled.eye,
                          size: 26,
                          valueKey: _obscureConfirmPassword,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureConfirmPassword = !_obscureConfirmPassword;
                          });
                        },
                      ),
                    ),
                    obscureText: _obscureConfirmPassword,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return localizations.confirm_your_password;
                      }
                      if (value != _passwordController.text) {
                        return localizations.password_is_not_same;
                      }
                      return null;
                    },
                  ),
                ],
                actionButton: AuthActionButton(
                  text: localizations.register_upper,
                  isLoading: authProvider.isLoadingRegister,
                  onPressed: _handleRegister,
                ),
                bottomLink: AuthBottomLink(
                  text: localizations.already_have_account,
                  linkText: localizations.login_lower,
                  onPressed: authProvider.isLoadingRegister
                      ? null
                      : () => context.go('/login'),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

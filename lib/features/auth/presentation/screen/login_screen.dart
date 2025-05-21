import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/model/user.dart';
import 'package:storyzz/core/design/theme.dart';
import 'package:storyzz/core/design/widgets/language_selector.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/providers/auth_provider.dart';
import 'package:storyzz/core/providers/settings_provider.dart';
import 'package:storyzz/core/utils/constants.dart';

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
      FocusScope.of(context).unfocus(); // close virtual keyboard
      final authProvider = context.read<AuthProvider>();
      final User user = User(
        email: _emailController.text,
        password: _passwordController.text,
      );

      final result = await authProvider.loginNetwork(
        user.email!,
        user.password!,
      );

      if (result.data != null && !result.data!.error) {
        if (mounted) {
          context.read<AuthProvider>().isLogged();
          // Determine if the screen is wide enough to display the NavigationRail
          bool isWideScreen =
              MediaQuery.of(context).size.width >= tabletBreakpoint;

          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              behavior: SnackBarBehavior.floating,
              margin:
                  isWideScreen
                      ? EdgeInsets.only(bottom: 16, left: 96, right: 16)
                      : EdgeInsets.only(bottom: 16, left: 16, right: 16),
              content: Text(AppLocalizations.of(context)!.login_succes),
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
                    AppLocalizations.of(context)!.login_failed,
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

    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        return Scaffold(
          extendBodyBehindAppBar: true,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            actions: [
              Consumer<SettingsProvider>(
                builder:
                    (context, provider, _) => Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: LanguageSelector(
                        currentLanguageCode: provider.locale.languageCode,
                        isCompact: true,
                      ),
                    ),
              ),
            ],
          ),
          body: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 400),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // logo/app title
                        Image.asset('assets/icon/icon.png', height: 80),
                        const SizedBox(height: 16),
                        Text(
                          localizations.welcome_back,
                          style: Theme.of(context).textTheme.headlineMedium,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          localizations.sign_in_to_continue,
                          style: Theme.of(context).textTheme.bodyLarge
                              ?.copyWith(color: Colors.grey.shade600),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 32),

                        // email field
                        Semantics(
                          label: localizations.email_form,
                          textField: true,
                          child: TextFormField(
                            enabled: !authProvider.isLoadingLogin,
                            controller: _emailController,
                            decoration: customInputDecoration(
                              label: localizations.email,
                              prefixIcon: Icons.email_outlined,
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

                        // password field
                        Semantics(
                          label: localizations.password_form,
                          textField: true,
                          child: TextFormField(
                            enabled: !authProvider.isLoadingLogin,
                            controller: _passwordController,
                            decoration: customInputDecoration(
                              label: localizations.password,
                              prefixIcon: Icons.lock_outline,
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_off
                                      : Icons.visibility,
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
                        ),
                        const SizedBox(height: 8),

                        // forgot password link
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed:
                                authProvider.isLoadingLogin
                                    ? null
                                    : () {
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            localizations.only_for_ui,
                                          ),
                                        ),
                                      );
                                    },
                            style: TextButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 8),
                              minimumSize: Size(50, 30),
                              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                            ),
                            child: Text(localizations.forgot_password),
                          ),
                        ),
                        const SizedBox(height: 24),

                        // login button
                        ElevatedButton(
                          onPressed:
                              authProvider.isLoadingLogin ? null : _handleLogin,
                          child:
                              authProvider.isLoadingLogin
                                  ? SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white,
                                      ),
                                    ),
                                  )
                                  : Text(localizations.login_upper),
                        ),
                        const SizedBox(height: 24),

                        // register link
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Flexible(
                              child: Text(
                                localizations.dont_have_account,
                                style: TextStyle(color: Colors.grey.shade600),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                context.read<AppProvider>().openRegister();
                              },
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.zero, // Reduce padding
                                minimumSize: Size(40, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8.0,
                                ),
                                child: Text(
                                  localizations.register_lower,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

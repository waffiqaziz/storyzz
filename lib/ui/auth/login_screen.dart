import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/model/user.dart';
import 'package:storyzz/core/designsystem/theme.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/provider/auth_provider.dart';
import 'package:storyzz/core/provider/settings_provider.dart';
import 'package:storyzz/ui/widgets/language_selector.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback onLogin;
  final VoidCallback onRegister;

  const LoginScreen({
    super.key,
    required this.onLogin,
    required this.onRegister,
  });

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
      if (result.data != null) {
        widget.onLogin();
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              margin: EdgeInsets.only(bottom: 16, left: 16, right: 16),
              content: Text(
                result.message ?? AppLocalizations.of(context)!.login_succes,
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result.message ?? AppLocalizations.of(context)!.login_failed,
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
                        onChanged: (code) => provider.setLocale(code),
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
                        TextFormField(
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
                        const SizedBox(height: 16),

                        // password field
                        TextFormField(
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
                            if (value.length < 6) {
                              return localizations.password_minimum;
                            }
                            return null;
                          },
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
                            Text(
                              localizations.dont_have_account,
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                            TextButton(
                              onPressed:
                                  authProvider.isLoadingLogin
                                      ? null
                                      : widget.onRegister,
                              style: TextButton.styleFrom(
                                padding: EdgeInsets.all(8),
                                minimumSize: Size(50, 30),
                                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                              ),
                              child: Text(localizations.register_lower),
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

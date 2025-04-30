import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:storyzz/core/data/model/user.dart';
import 'package:storyzz/core/designsystem/theme.dart';
import 'package:storyzz/core/localization/l10n/app_localizations.dart';
import 'package:storyzz/core/providers/app_provider.dart';
import 'package:storyzz/core/providers/auth_provider.dart';
import 'package:storyzz/core/providers/settings_provider.dart';
import 'package:storyzz/core/widgets/language_selector.dart';

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
      final authProvider = context.read<AuthProvider>();
      final User user = User(
        name: _nameController.text,
        email: _emailController.text,
        password: _passwordController.text,
      );

      final result = await authProvider.register(user);
      if (result.data != null && !result.data!.error) {
        if (mounted) {
          context.go('/');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result.message ??
                    AppLocalizations.of(context)!.register_success,
              ),
            ),
          );
        }
      } else {
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                result.message ?? AppLocalizations.of(context)!.register_failed,
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
                    // header
                    Image.asset('assets/icon/icon.png', height: 80),
                    const SizedBox(height: 16),
                    Text(
                      localizations.create_account,
                      style: Theme.of(context).textTheme.headlineMedium,
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      localizations.sign_up_to_get_started,
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 32),

                    // name field
                    TextFormField(
                      controller: _nameController,
                      decoration: customInputDecoration(
                        label: localizations.full_name,
                        prefixIcon: Icons.person_outline,
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
                    const SizedBox(height: 16),

                    // confirm password field
                    TextFormField(
                      controller: _confirmPasswordController,
                      decoration: customInputDecoration(
                        label: localizations.confirm_password,
                        prefixIcon: Icons.lock_outline,
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscureConfirmPassword
                                ? Icons.visibility_off
                                : Icons.visibility,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscureConfirmPassword =
                                  !_obscureConfirmPassword;
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
                    const SizedBox(height: 24),

                    // register Button
                    Consumer<AuthProvider>(
                      builder: (context, authProvider, child) {
                        return ElevatedButton(
                          onPressed:
                              authProvider.isLoadingRegister
                                  ? null
                                  : _handleRegister,
                          child:
                              authProvider.isLoadingRegister
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
                                  : Text(localizations.register_upper),
                        );
                      },
                    ),
                    const SizedBox(height: 24),

                    // login link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          localizations.already_have_account,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                        TextButton(
                          onPressed:
                              () => context.read<AppProvider>().openLogin(),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.all(8),
                            minimumSize: Size(50, 30),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(localizations.login_lower),
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
  }
}

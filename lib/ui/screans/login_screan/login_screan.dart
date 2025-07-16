import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:event_planning_app/core/App_assets/image_assets.dart';
import 'package:event_planning_app/core/themes/app_colors.dart';
import 'package:event_planning_app/core/firebasehulpers/auth/firebase_auth_methods.dart';
import 'package:event_planning_app/utiles/provider_extintion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/firebasehulpers/store/firestore_hulpers.dart';
import '../../../core/providers/app_local_provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/providers/theme_provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../bottum_navigation/button_navigation_bar.dart';
import '../rigester/sinup_screan.dart';

class LoginScrean extends StatefulWidget {
  LoginScrean({super.key});

  static const String routName = '/loginscrean';

  @override
  State<LoginScrean> createState() => _LoginScreanState();
}

class _LoginScreanState extends State<LoginScrean> {
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;
  late AppProvider appProvider;
  late AppLocaleProvider appLocaleProvider;

  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();
  var formKey = GlobalKey<FormState>();
  bool obscureText = true;

  @override
  void dispose() {
    controllerEmail.dispose();
    controllerPassword.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appProvider = context.appProvider;
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocaleProvider = Provider.of<AppLocaleProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;

    void toggleVisibility() {
      setState(() {
        obscureText = !obscureText;
      });
    }

    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: formKey,
                child: Column(
                  children: [
                    Center(
                      child: Image.asset(
                        ImageAssets.verticalLogo,
                        width: MediaQuery.of(context).size.width * 0.3,
                      ),
                    ),
                    const SizedBox(height: 24),
                    TextFormField(
                      controller: controllerEmail,
                      decoration: InputDecoration(
                        hintText: appLocalizations.email,
                        prefixIcon: const Icon(Icons.email),
                      ),
                      validator: (email) {
                        if (email == null || email.isEmpty) {
                          return 'email is required';
                        }
                        final bool emailValid = RegExp(
                            r"^[a-zA-Z0-9.+_-]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(email);
                        if (!emailValid) {
                          return 'email is not valid';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      obscureText: obscureText,
                      controller: controllerPassword,
                      decoration: InputDecoration(
                        hintText: appLocalizations.password,
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          onPressed: toggleVisibility,
                          icon: obscureText
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility),
                        ),
                      ),
                      validator: (password) {
                        if (password == null || password.isEmpty) {
                          return 'password is required';
                        }
                        if (password.length < 6) {
                          return 'password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () {},
                          child: Text(appLocalizations.forgetPassword),
                        ),
                      ],
                    ),
                    SizedBox(
                      width: double.infinity,
                      height: 60,
                      child: LoginButton(context),
                    ),
                    const SizedBox(height: 24),
                    signUpRow(context),
                    const SizedBox(height: 24),
                    buildOrText(context),
                    googleLogin(context),
                    const SizedBox(height: 24),
                    AnimatedToggleSwitch.rolling(
                      style: const ToggleStyle(
                        backgroundColor: Colors.transparent,
                        indicatorColor: AppColors.primaryPurple,
                        borderColor: AppColors.primaryPurple,
                      ),
                      onChanged: (value) {
                        appLocaleProvider.AppLocal = value;
                      },
                      current: appLocaleProvider.AppLocal,
                      values: ['ar', 'en'],
                      iconBuilder: (value, foreground) {
                        return CircleAvatar(
                          backgroundImage: AssetImage(
                            value == 'en'
                                ? ImageAssets.english
                                : ImageAssets.arabic,
                          ),
                        );
                      },
                    )
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  FilledButton LoginButton(BuildContext context) {
    return FilledButton(
      onPressed: () async {
        if (!formKey.currentState!.validate()) return;

        showLoading(context);

        try {
          final credential = await FirebaseAuth.instance
              .signInWithEmailAndPassword(
            email: controllerEmail.text.trim(),
            password: controllerPassword.text.trim(),
          );

          final userData = await getUserfromFirestore(credential.user!.uid);
          appProvider.updateUser(userData);

          // Hide loading before navigation
          if (mounted) {
            hideLoading(context);

            // Navigate to home screen
            Navigator.pushReplacementNamed(context, ButtonNavigationBar.routeName);
          }
        } on FirebaseAuthException catch (e) {
          if (mounted) {
            hideLoading(context);

            // Show error message
            showMassege(
              _getErrorMessage(e.code),
              context,
              title: 'Login Error',
              postiveButtonTitle: 'OK',
              postiveButtonClick: () {},
            );
          }
        } catch (e) {
          if (mounted) {
            hideLoading(context);

            showMassege(
              'An unexpected error occurred. Please try again.',
              context,
              title: 'Error',
              postiveButtonTitle: 'OK',
              postiveButtonClick: () {},
            );
          }
        }
      },
      child: Text(appLocalizations.login),
    );
  }

  String _getErrorMessage(String errorCode) {
    switch (errorCode) {
      case 'user-not-found':
        return 'No user found with this email address.';
      case 'wrong-password':
        return 'Invalid password. Please try again.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'user-disabled':
        return 'This account has been disabled.';
      case 'too-many-requests':
        return 'Too many login attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'Login failed. Please try again.';
    }
  }

  Row signUpRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          appLocalizations.do_not_have_any_account,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        TextButton(
          onPressed: () {
            Navigator.pushNamed(context, SinupScrean.routName);
          },
          child: Text(appLocalizations.create_email),
        ),
      ],
    );
  }

  Row buildOrText(BuildContext context) {
    return Row(
      children: [
        const Expanded(
          child: Divider(color: AppColors.primaryPurple),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            appLocalizations.or,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
        const Expanded(
          child: Divider(color: AppColors.primaryPurple),
        ),
      ],
    );
  }

  SizedBox googleLogin(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 60,
      child: FilledButton(
        style: FilledButton.styleFrom(
          side: const BorderSide(color: AppColors.primaryPurple),
          backgroundColor: AppColors.bgwhite,
        ),
        onPressed: () {
          // Google login logic (optional)
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(ImageAssets.google),
            const SizedBox(width: 10),
            Text(
              appLocalizations.login_with_google,
              style: Theme.of(context).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }
}
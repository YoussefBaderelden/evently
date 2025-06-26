import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:event_planning_app/core/models/userDM.dart';
import 'package:event_planning_app/ui/screans/login_screan/login_screan.dart';
import 'package:event_planning_app/core/firebasehulpers/auth/firebase_auth_methods.dart';
import 'package:event_planning_app/ui/screans/shared_wedgit/app_bar_view.dart';
import 'package:event_planning_app/utiles/provider_extintion.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../../../core/App_assets/image_assets.dart';
import '../../../core/firebasehulpers/store/firestore_hulpers.dart';
import '../../../core/providers/app_local_provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/themes/app_colors.dart';
import '../bottum_navigation/button_navigation_bar.dart';

class SinupScrean extends StatefulWidget {
  SinupScrean({super.key});

  static const routName = '/sinup';

  @override
  State<SinupScrean> createState() => _SinupScreanState();
}

class _SinupScreanState extends State<SinupScrean> {
  late AppLocalizations appLocalizations;
  late AppProvider appProvider;

  late AppLocaleProvider appLocaleProvider;

  TextEditingController controllerEmail = TextEditingController();
  TextEditingController controllername = TextEditingController();
  TextEditingController controllerPassword = TextEditingController();

  bool obscureTextpassword = true;
  bool obscureTextrepassword = true;

  @override
  Widget build(BuildContext context) {
    appProvider = context.appProvider;
    void passwordVisability() {
      setState(() {
        obscureTextpassword = !obscureTextpassword;
      });
    }

    void repasswordVisability() {
      setState(() {
        obscureTextrepassword = !obscureTextrepassword;
      });
    }

    appLocaleProvider = Provider.of<AppLocaleProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBarView(
        title: appLocalizations.registar,
        color: AppColors.black,
      ),
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Center(
                    child: Image.asset(
                  ImageAssets.verticalLogo,
                  width: MediaQuery.of(context).size.width * 0.4,
                )),
                const SizedBox(
                  height: 24,
                ),
                TextFormField(
                  controller: controllername,
                  decoration: InputDecoration(
                      hintText: appLocalizations.name,
                      prefixIcon: Icon(Icons.person)),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  controller: controllerEmail,
                  decoration: InputDecoration(
                    hintText: appLocalizations.email,
                    prefixIcon: Icon(Icons.email),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  obscureText: obscureTextpassword,
                  controller: controllerPassword,
                  decoration: InputDecoration(
                      hintText: appLocalizations.password,
                      suffixIcon: IconButton(
                          onPressed: passwordVisability,
                          icon: obscureTextpassword
                              ? const Icon(Icons.visibility_off)
                              : const Icon(Icons.visibility)),
                      prefixIcon: const Icon(Icons.lock)),
                ),
                const SizedBox(
                  height: 16,
                ),
                TextFormField(
                  obscureText: obscureTextrepassword,
                  decoration: InputDecoration(
                    hintText: appLocalizations.repassword,
                    prefixIcon: const Icon(Icons.lock),
                    suffixIcon: IconButton(
                        onPressed: repasswordVisability,
                        icon: obscureTextrepassword
                            ? const Icon(Icons.visibility_off)
                            : const Icon(Icons.visibility)),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                SizedBox(
                    width: double.infinity,
                    height: 60,
                    child: FilledButton(
                        onPressed: () async {
                          try {
                            showLoading(context);
                            final credential = await FirebaseAuth.instance
                                .createUserWithEmailAndPassword(
                              email: controllerEmail.text,
                              password: controllerPassword.text,
                            );
                            Userdm newUser = Userdm(
                              email: controllerEmail.text,
                              name: controllername.text,
                              uid: credential.user!.uid,
                            );
                            await addUserToFirestore(newUser);
                            appProvider.updateUser(
                                await getUserfromFirestore(newUser.uid));
                            hideLoading(context);
                            Navigator.pushNamed(
                                context, ButtonNavigationBar.routeName);
                          } on FirebaseAuthException catch (e) {
                            hideLoading(context);
                            final bool emailValid = RegExp(
                                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                .hasMatch(controllerEmail.text);
                            if (emailValid == false) {
                              showMassege(
                                  'this email is badly formated', context,
                                  postiveButtonTitle: 'ok',
                                  postiveButtonClick: () {});
                            } else if (controllerPassword.text.length < 6) {
                              showMassege(
                                  'The password must be more than 6 characters',
                                  context,
                                  postiveButtonTitle: 'ok',
                                  postiveButtonClick: () {});
                            } else if (e.code == 'email-already-in-use') {
                              showMassege(
                                  'The account already exists for that email.',
                                  context,
                                  postiveButtonTitle: 'ok',
                                  postiveButtonClick: () {});
                            } else {
                              showMassege(e.code, context);
                            }
                          }
                        },
                        child: Text(appLocalizations.create_email))),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      appLocalizations.already_have_an_account,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, LoginScrean.routName);
                        },
                        child: Text(appLocalizations.login)),
                  ],
                ),
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
                    if (value == 'en') {
                      return const CircleAvatar(
                        backgroundImage: AssetImage(ImageAssets.english),
                      );
                    } else {
                      return const CircleAvatar(
                        backgroundImage: AssetImage(ImageAssets.arabic),
                      );
                    }
                  },
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:event_planning_app/core/App_assets/image_assets.dart';
import 'package:event_planning_app/core/models/userDM.dart';
import 'package:event_planning_app/ui/screans/login_screan/login_screan.dart';
import 'package:event_planning_app/utiles/provider_extintion.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_local_provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/themes/app_colors.dart';

class Profile extends StatefulWidget {
  Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  late ThemeProvider themeProvider;
  late AppProvider appProvider;

  late AppLocaleProvider appLocaleProvider;

  late AppLocalizations appLocalizations;

  String language = '';
  String theme = '';


  @override
  Widget build(BuildContext context) {
    appProvider = context.appProvider;
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocaleProvider = Provider.of<AppLocaleProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          buildAppBarContainer(context),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                 appLocalizations.language,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                buildLanguageContainer(context),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Text(
                  appLocalizations.theme,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                buildThemeContainer(context),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.28,
                ),
                buildLogoutButton(context)
              ],
            ),
          ),
        ],
      ),
    );
  }

  SizedBox buildLogoutButton(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.07,
      width: double.infinity,
      child: FilledButton(
          style: FilledButton.styleFrom(backgroundColor: AppColors.red),
          onPressed: () {
            Navigator.pushReplacementNamed(context, LoginScrean.routName);
          },
          child:  Row(
            children: [
            const  Icon(
                Icons.logout,
                color: AppColors.bgwhite,
                size: 30,
              ),
              Text(
                appLocalizations.logout,
                style:const TextStyle(
                    color: AppColors.bgwhite,
                    fontSize: 23,
                    fontWeight: FontWeight.w500),
              )
            ],
          )),
    );
  }

  Container buildThemeContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: themeProvider.isDark()
            ? AppColors.bgDarkDarkPurple
            : AppColors.bgwhite,
        border: Border.all(color: AppColors.primaryPurple),
      ),
      child: Row(
        children: [
          Text(
           theme ,
            style: const TextStyle(
                fontSize: 16,
                color: AppColors.primaryPurple,
                fontWeight: FontWeight.bold),
          ),
         const  Spacer(),
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title:  Text(appLocalizations.choose_theme),
                      content: Row(children: [
                        FilledButton(
                          onPressed: () {
                            themeProvider.setThemeMode = ThemeMode.light;
                            theme = appLocalizations.light;
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child:  Text(appLocalizations.light),
                        ),
                        const Spacer(),
                        FilledButton(
                          onPressed: () {
                            themeProvider.setThemeMode = ThemeMode.dark;
                            theme = appLocalizations.dark;
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child:  Text(appLocalizations.dark),
                        ),
                      ]),
                    );
                  });
            },
            child: const Icon(
              Icons.arrow_drop_down,
              color: AppColors.primaryPurple,
              textDirection: TextDirection.rtl,
            ),
          )
        ],
      ),
    );
  }

  Container buildLanguageContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(6),
      width: double.infinity,
      height: MediaQuery.of(context).size.height * 0.06,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: themeProvider.isDark()
            ? AppColors.bgDarkDarkPurple
            : AppColors.bgwhite,
        border: Border.all(color: AppColors.primaryPurple),
      ),
      child: Row(
        children: [
          Text(
            language,
            style: const TextStyle(
                fontSize: 16,
                color: AppColors.primaryPurple,
                fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          InkWell(
            onTap: () {
              showDialog(
                  context: context,
                  builder: (context) {
                    return CupertinoAlertDialog(
                      title:  Text(appLocalizations.choose_language),
                      content: Row(children: [
                        FilledButton(
                          onPressed: () {
                            appLocaleProvider.AppLocal = 'en';
                            language = appLocalizations.english;
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child:  Text(appLocalizations.english),
                        ),
                        const Spacer(),
                        FilledButton(
                          onPressed: () {
                            appLocaleProvider.AppLocal = 'ar';
                            language = appLocalizations.arabic;
                            setState(() {});
                            Navigator.pop(context);
                          },
                          child:  Text(appLocalizations.arabic),
                        ),
                      ]),
                    );
                  });
            },
            child: const Icon(
              Icons.arrow_drop_down,
              color: AppColors.primaryPurple,
              textDirection: TextDirection.rtl,
            ),
          )
        ],
      ),
    );
  }

  Container buildAppBarContainer(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 100, left: 16, right: 16, bottom: 16),
      height: MediaQuery.of(context).size.height * 0.3,
      decoration:const BoxDecoration(
        color: AppColors.primaryPurple,
        borderRadius:  BorderRadius.only(
          bottomLeft: Radius.circular(64),
        ),
      ),
      child: Row(
        children: [
          Image.asset(ImageAssets.profilepic),
          SizedBox(
            width: MediaQuery.of(context).size.width * 0.03,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
               Text(
                 appProvider.curentUser.name,
                style:const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 30,
                    color: AppColors.bgwhite),
              ),
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.01,
              ),
               Text(
                appProvider.curentUser.email,
                style:const TextStyle(
                    fontWeight: FontWeight.w400,
                    fontSize: 22,
                    color: AppColors.bgwhite),
              )
            ],
          )
        ],
      ),
    );
  }
}

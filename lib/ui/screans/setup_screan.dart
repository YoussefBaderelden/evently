import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:event_planning_app/core/App_assets/image_assets.dart';
import 'package:event_planning_app/core/providers/theme_provider.dart';
import 'package:event_planning_app/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../core/providers/app_local_provider.dart';
import 'onboarding_screan/onboarding_screan.dart';

class SetupScrean extends StatelessWidget {
  SetupScrean({super.key});

  static const String routName = '/setupScrean';
  late ThemeProvider themeProvider;
  late AppLocalizations appLocalizations;
  late AppLocaleProvider appLocaleProvider;

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocaleProvider = Provider.of<AppLocaleProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      body: Directionality(
        textDirection: TextDirection.ltr,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  ImageAssets.horizontalLogo,
                  width: MediaQuery.of(context).size.width * 0.5,
                ),
                Expanded(
                    child: themeProvider.isDark()
                        ? Image.asset(ImageAssets.setupDark)
                        : Image.asset(ImageAssets.setupLight)),
                Text(
                  appLocalizations.setupTitle,
                  style: Theme.of(context).textTheme.labelLarge,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                Text(
                  appLocalizations.setupSubTitle,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      appLocalizations.language,
                      style: Theme.of(context).textTheme.labelLarge,
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
                      values:const ['ar', 'en'],
                      iconBuilder: (value, foreground) {
                        if (value == 'en') {
                          return const CircleAvatar(
                            backgroundImage: AssetImage(ImageAssets.arabic),
                          );
                        } else {
                          return const CircleAvatar(
                            backgroundImage: AssetImage(ImageAssets.english),
                          );
                        }
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.01,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      appLocalizations.theme,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                    AnimatedToggleSwitch.rolling(
                      style: const ToggleStyle(
                        backgroundColor: Colors.transparent,
                        indicatorColor: AppColors.primaryPurple,
                        borderColor: AppColors.primaryPurple,
                      ),
                      onChanged: (value) {
                        themeProvider.setThemeMode = value;
                      },
                      current: themeProvider.getThemeMode,
                      values: const [ThemeMode.dark, ThemeMode.light],
                      iconBuilder: (value, foreground) {
                        if (value == ThemeMode.dark) {
                          return Icon(Icons.nightlight,
                              color: !themeProvider.isDark()
                                  ? Theme.of(context).primaryColor
                                  : Theme.of(context).scaffoldBackgroundColor);
                        } else {
                          return Icon(
                            Icons.sunny,
                            color: themeProvider.isDark()
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).scaffoldBackgroundColor,
                          );
                        }
                      },
                    )
                  ],
                ),
                SizedBox(
                  height: MediaQuery.of(context).size.height * 0.025,
                ),
                SizedBox(
                  height: 60,
                  width: double.infinity,
                  child: FilledButton(
                      onPressed: () {
                        Navigator.pushReplacementNamed(
                            context, OnboardingScrean.routeName);
                      },
                      child: Text(appLocalizations.setupClick)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

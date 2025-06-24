import 'package:event_planning_app/core/themes/app_colors.dart';
import 'package:event_planning_app/ui/screans/Map/map.dart';
import 'package:event_planning_app/ui/screans/home/home_screan.dart';
import 'package:event_planning_app/ui/screans/love/love.dart';
import 'package:event_planning_app/ui/screans/profile/profile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../../core/App_assets/image_assets.dart';
import '../../../core/providers/app_local_provider.dart';
import '../../../core/providers/theme_provider.dart';

class ButtonNavigationBar extends StatefulWidget {
  const ButtonNavigationBar({super.key});

  static const routeName = '/buttonNavigationBar';

  @override
  State<ButtonNavigationBar> createState() => _ButtonNavigationBarState();
}

class _ButtonNavigationBarState extends State<ButtonNavigationBar> {
  late ThemeProvider themeProvider;
  late AppLocaleProvider appLocaleProvider;
  late AppLocalizations appLocalizations;

  int screanIndex = 0;
  final List<Widget> navigationScreens = [
    HomeScrean(),
    MapScrean(),
    Love(),
    Profile(),
  ];

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocaleProvider = Provider.of<AppLocaleProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        bottomNavigationBar: BottomNavigationBar(
          onTap: (value) => setState(() => screanIndex = value),
          currentIndex: screanIndex,
          items: [
            BottomNavigationBarItem(
              backgroundColor: themeProvider.isDark()
                  ? AppColors.bgDarkDarkPurple
                  : AppColors.primaryPurple,
              icon: screanIndex == 0
                  ? const ImageIcon(AssetImage(ImageAssets.home))
                  : const ImageIcon(AssetImage(ImageAssets.homeUnActive)),
              label: appLocalizations.home,
            ),
            BottomNavigationBarItem(
              backgroundColor: themeProvider.isDark()
                  ? AppColors.bgDarkDarkPurple
                  : AppColors.primaryPurple,
              icon: screanIndex == 1
                  ? const ImageIcon(AssetImage(ImageAssets.map))
                  : const ImageIcon(AssetImage(ImageAssets.mapUnActive)),
              label: appLocalizations.location,
            ),
            BottomNavigationBarItem(
              backgroundColor: themeProvider.isDark()
                  ? AppColors.bgDarkDarkPurple
                  : AppColors.primaryPurple,
              icon: screanIndex == 2
                  ? const ImageIcon(AssetImage(ImageAssets.love))
                  : const ImageIcon(AssetImage(ImageAssets.loveUnActive)),
              label: appLocalizations.favourites,
            ),
            BottomNavigationBarItem(
              backgroundColor: themeProvider.isDark()
                  ? AppColors.bgDarkDarkPurple
                  : AppColors.primaryPurple,
              icon: screanIndex == 3
                  ? const ImageIcon(AssetImage(ImageAssets.profile))
                  : const ImageIcon(AssetImage(ImageAssets.profileUnActive)),
              label: appLocalizations.profile,
            ),
          ],
        ),
        body: navigationScreens[screanIndex],
      ),
    );
  }
}

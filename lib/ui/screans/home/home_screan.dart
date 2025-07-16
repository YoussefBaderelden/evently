import 'package:event_planning_app/core/App_assets/image_assets.dart';
import 'package:event_planning_app/core/firebasehulpers/store/firestore_hulpers.dart';
import 'package:event_planning_app/core/models/categoryDm.dart';
import 'package:event_planning_app/core/providers/theme_provider.dart';
import 'package:event_planning_app/core/themes/app_colors.dart';
import 'package:event_planning_app/ui/screans/shared_wedgit/TabBarWidget.dart';
import 'package:event_planning_app/utiles/provider_extintion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../core/models/eventDM.dart';
import '../../../core/providers/app_local_provider.dart';
import '../../../core/providers/app_provider.dart';
import '../eventScrean/create_event_screan.dart';
import 'dart:ui' as ui;
import '../eventScrean/event_ditels.dart';

class HomeScrean extends StatefulWidget {
  HomeScrean({super.key});
  static const routeName = '/home';

  @override
  State<HomeScrean> createState() => _HomeScreanState();
}

class _HomeScreanState extends State<HomeScrean> with TickerProviderStateMixin {
  late ThemeProvider themeProvider;
  late AppLocaleProvider appLocaleProvider;
  late AppProvider appProvider;
  late AppLocalizations appLocalizations;
  late TabController tabController;
  Categorydm selectedCategory = Categorydm.categorieswithAll[0];

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 9, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    appProvider = context.appProvider;
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocaleProvider = Provider.of<AppLocaleProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;

    if (appProvider.curentUser == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Directionality(
      textDirection: ui.TextDirection.ltr,
      child: Scaffold(
        body: Column(
          children: [
            Container(
              padding: const EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 16),
              height: MediaQuery.of(context).size.height * 0.25,
              decoration: BoxDecoration(
                color: themeProvider.isDark()
                    ? AppColors.bgDarkDarkPurple
                    : AppColors.primaryPurple,
                borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(24), bottomRight: Radius.circular(24)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text('${appLocalizations.welcomeBack} ✨',
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.bgwhite,
                              )),
                          Text(appProvider.curentUser!.name,
                              style: const TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.bgwhite,
                              )),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {
                            if (themeProvider.getThemeMode == ThemeMode.dark) {
                              themeProvider.setThemeMode = ThemeMode.light;
                            } else {
                              themeProvider.setThemeMode = ThemeMode.dark;
                            }
                            setState(() {});
                          },
                          icon: const Icon(
                            Icons.wb_sunny_outlined,
                            color: AppColors.ofWhite,
                          )),
                      InkWell(
                        onTap: () {
                          appLocaleProvider.AppLocal =
                          appLocaleProvider.AppLocal == 'en' ? 'ar' : 'en';
                          setState(() {});
                        },
                        child: Container(
                          alignment: Alignment.center,
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                              color: AppColors.ofWhite,
                              borderRadius: BorderRadius.circular(12)),
                          child: Text(
                            appLocaleProvider.AppLocal == 'en' ? 'AR' : 'EN',
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.primaryPurple),
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Image.asset(
                        ImageAssets.location,
                        width: MediaQuery.of(context).size.width * 0.05,
                      ),
                      const SizedBox(width: 4),
                      const Text(
                        'Cairo , Egypt',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: AppColors.bgwhite,
                        ),
                      )
                    ],
                  ),
                  buildTabBar(),
                ],
              ),
            ),
            StreamBuilder<List<EventDM>>(
              stream: getEventsByCategory(selectedCategory.name),
              builder: (context, snapShot) {
                if (snapShot.hasData) {
                  var events = snapShot.data!;
                  return events.isEmpty
                      ? const Center(child: Text('No Events'))
                      : buildTabBarView(themeProvider, snapShot.data!);
                } else if (snapShot.hasError) {
                  return Center(child: Text('${snapShot.error}'));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(36),
              side: const BorderSide(color: AppColors.bgwhite, width: 2)),
          backgroundColor: themeProvider.isDark()
              ? AppColors.bgDarkDarkPurple
              : AppColors.primaryPurple,
          onPressed: () {
            Navigator.pushNamed(context, CreateEventScrean.routeName);
          },
          child: const Icon(Icons.add, color: AppColors.bgwhite),
        ),
      ),
    );
  }

  Widget buildTabBarView(ThemeProvider themeProvider, List<EventDM> events) {
    return Expanded(
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => EventDitels(
                    event: events[index],
                  ),
                ),
              );
            },
            child: Stack(
              alignment: AlignmentDirectional.topStart,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Container(
                    width: double.infinity,
                    height: MediaQuery.of(context).size.height * 0.27,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      color: themeProvider.isDark()
                          ? AppColors.bgDarkDarkPurple
                          : AppColors.black,
                      border: Border.all(color: AppColors.primaryPurple),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text(Categorydm.fromName(events[index].category).name,
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.isDark()
                                  ? AppColors.ofWhite
                                  : AppColors.bgwhite,
                            )),
                        Image.asset(
                          Categorydm.fromName(events[index].category).image,
                          width: MediaQuery.of(context).size.width * 0.4,
                          fit: BoxFit.cover,
                        ),
                      ],
                    ),
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height * 0.08,
                      width: MediaQuery.of(context).size.width * 0.13,
                      margin: const EdgeInsets.all(26),
                      decoration: BoxDecoration(
                        color: themeProvider.isDark()
                            ? AppColors.bgDarkDarkPurple
                            : AppColors.bgwhite,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        children: [
                          Text(
                            '${events[index].date.day}',
                            style: const TextStyle(
                                color: AppColors.primaryPurple,
                                fontSize: 24,
                                fontWeight: FontWeight.bold),
                          ),
                          Text(
                            DateFormat('MMM').format(events[index].date),
                            style: const TextStyle(
                                color: AppColors.primaryPurple,
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.04),
                    Container(
                      height: MediaQuery.of(context).size.height * 0.06,
                      width: double.infinity,
                      margin: const EdgeInsets.all(26),
                      decoration: BoxDecoration(
                        color: themeProvider.isDark()
                            ? AppColors.bgDarkDarkPurple
                            : AppColors.bgwhite,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              events[index].title,
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.isDark()
                                    ? AppColors.bgwhite
                                    : AppColors.black,
                              ),
                            ),
                            const Spacer(),
                            buildImageIcon(events[index].id)
                          ],
                        ),
                      ),
                    )
                  ],
                )
              ],
            ),
          );
        },
      ),
    );
  }

  Widget buildImageIcon(String eventId) {
    bool isFav = appProvider.curentUser?.isfavouriteevent(eventId) ?? false;
    return InkWell(
      onTap: () {
        if (isFav) {
          appProvider.removeFromFavouriteEvent(eventId);
        } else {
          appProvider.addToFavouriteEvent(eventId);
        }
      },
      child: isFav
          ? const ImageIcon(
        AssetImage(ImageAssets.favourt),
        color: AppColors.primaryPurple,
      )
          : const ImageIcon(
        AssetImage(ImageAssets.favourtUnActive),
        color: AppColors.primaryPurple,
      ),
    );
  }

  Tabbarwidget buildTabBar() {
    return Tabbarwidget(
      category: Categorydm.categorieswithAll,
      categoryClicked: (category) {
        selectedCategory = category;
        setState(() {});
      },
      tabController: tabController,
      inhome: true,
    );
  }
}
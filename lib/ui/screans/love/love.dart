import 'package:event_planning_app/core/themes/app_colors.dart';
import 'package:event_planning_app/utiles/provider_extintion.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/App_assets/image_assets.dart';
import '../../../core/firebasehulpers/store/firestore_hulpers.dart';
import '../../../core/models/categoryDm.dart';
import '../../../core/models/eventDM.dart';
import '../../../core/providers/app_local_provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/providers/theme_provider.dart';

class Love extends StatefulWidget {
  Love({super.key});

  @override
  State<Love> createState() => _LoveState();
}

class _LoveState extends State<Love> {
  late ThemeProvider themeProvider;
  late AppLocaleProvider appLocaleProvider;
  late AppProvider appProvider;
  late AppLocalizations appLocalizations;

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appProvider = context.appProvider;
    appLocaleProvider = Provider.of<AppLocaleProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            FutureBuilder<List<EventDM>>(
              future: getFavEvents(appProvider.curentUser!),
              builder: (context, snapShot) {
                if (snapShot.hasData) {
                  var events = snapShot.data!;
                  return events.isEmpty
                      ? const Center(
                          child: Text(
                          'No Favorite  Events yet',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w500,
                            color: AppColors.primaryPurple,
                          ),
                        ))
                      : buildFilterdEvents(themeProvider, snapShot.data!);
                } else if (snapShot.hasError) {
                  return Center(child: Text('${snapShot.error}'));
                } else {
                  return const Center(child: CircularProgressIndicator());
                }
              },
            )
          ],
        ),
      ),
    );
  }

  Expanded buildFilterdEvents(
      ThemeProvider themeProvider, List<EventDM> events) {
    return Expanded(
      child: ListView.builder(
        itemCount: events.length,
        itemBuilder: (context, index) {
          return Stack(
            alignment: AlignmentDirectional.topStart,
            children: [
              Padding(
                padding: const EdgeInsets.all(16),
                child: Container(
                  width: double.infinity,
                  height: MediaQuery.of(context).size.height * 0.25,
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
                    height: MediaQuery.of(context).size.height * 0.07,
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
                          buildImageIcon(events[index].id, appProvider),
                        ],
                      ),
                    ),
                  )
                ],
              )
            ],
          );
        },
      ),
    );
  }
}

Widget buildImageIcon(String eventId, AppProvider appProvider) {
  bool isFav = appProvider.curentUser!.isfavouriteevent(eventId);
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

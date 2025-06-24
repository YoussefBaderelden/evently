import 'package:event_planning_app/core/themes/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import '../../../core/App_assets/image_assets.dart';
import '../../../core/providers/app_local_provider.dart';
import '../../../core/providers/theme_provider.dart';

class Love extends StatefulWidget {
  Love({super.key});

  @override
  State<Love> createState() => _LoveState();
}

class _LoveState extends State<Love> {
  late ThemeProvider themeProvider;
  late AppLocaleProvider appLocaleProvider;
  late AppLocalizations appLocalizations;

  List<String> Images = [
    ImageAssets.sport,
    ImageAssets.birthday,
    ImageAssets.meating,
    ImageAssets.gaming,
    ImageAssets.eating,
    ImageAssets.holiday,
    ImageAssets.exhaping,
    ImageAssets.workShop,
    ImageAssets.book,
  ];

  List<String> Titels = [
    'Sport',
    'Birthday',
    'Meeting',
    'Gaming',
    'Eating',
    'Holiday',
    'Exhaping',
    'WorkShop',
    'Book',
  ];

  @override
  Widget build(BuildContext context) {
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocaleProvider = Provider.of<AppLocaleProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            buildSearchTextField(),
            buildFilterdEvents(),
          ],
        ),
      ),
    );
  }

  Expanded buildFilterdEvents() {
    return Expanded(
      child: ListView.builder(
        itemCount: Images.length,
        itemBuilder: (context, index) {
          return Stack(
            alignment: AlignmentDirectional.bottomStart,
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
                        Text(Titels[index],
                            style: TextStyle(
                              fontSize: 48,
                              fontWeight: FontWeight.bold,
                              color: themeProvider.isDark()
                                  ? AppColors.ofWhite
                                  : AppColors.bgwhite,
                            )),
                        Image.asset(
                          Images[index],
                          width: MediaQuery.of(context).size.width * 0.4,
                          fit: BoxFit.cover,
                        ),
                      ],
                    )),
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
                    child:const Column(
                      children: [
                        Text(
                          '21',
                          style: TextStyle(
                              color: AppColors.primaryPurple,
                              fontSize: 24,
                              fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'Nov',
                          style: TextStyle(
                              color: AppColors.primaryPurple,
                              fontSize: 18,
                              fontWeight: FontWeight.bold),
                        ),

                      ],
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.04,),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.06,
                    width: double.infinity,
                    margin: const EdgeInsets.all(26),
                    decoration: BoxDecoration(
                        color: themeProvider.isDark()
                            ? AppColors.bgDarkDarkPurple
                            : AppColors.bgwhite,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'This is a Birthday Party ',
                            style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: themeProvider.isDark()
                                    ? AppColors.bgwhite
                                    : AppColors.black),
                          ),
                          const Spacer(),
                          index == 0
                              ? const ImageIcon(
                            AssetImage(ImageAssets.favourt),
                            color: AppColors.primaryPurple,
                          )
                              : const ImageIcon(
                            AssetImage(ImageAssets.favourtUnActive),
                            color: AppColors.primaryPurple,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ],
          );
        },
      ),
    );
  }

  Padding buildSearchTextField() {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      child: TextField(
        decoration: InputDecoration(
          hintText: appLocalizations.search_for_event,
          prefixIcon: const Icon(
            Icons.search,
          ),
        ),
      ),
    );
  }
}

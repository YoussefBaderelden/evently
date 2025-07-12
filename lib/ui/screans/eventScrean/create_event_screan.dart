import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:event_planning_app/core/firebasehulpers/auth/firebase_auth_methods.dart';
import 'package:event_planning_app/core/firebasehulpers/store/firestore_hulpers.dart';
import 'package:event_planning_app/core/models/categoryDm.dart';
import 'package:event_planning_app/core/models/eventDM.dart';
import 'package:event_planning_app/core/themes/app_colors.dart';
import 'package:event_planning_app/utiles/provider_extintion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';
import '../../../core/App_assets/image_assets.dart';
import '../../../core/providers/app_local_provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/providers/event_map_screan_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../shared_wedgit/TabBarWidget.dart';
import '../shared_wedgit/app_bar_view.dart';
import 'map_event_screan.dart';

class CreateEventScrean extends StatefulWidget {
  CreateEventScrean({super.key});

  static const String routeName = '/createEvent';

  @override
  State<CreateEventScrean> createState() => _CreateEventScreanState();
}

class _CreateEventScreanState extends State<CreateEventScrean>
    with TickerProviderStateMixin {
  late ThemeProvider themeProvider;
  late AppLocaleProvider appLocaleProvider;
  late AppLocalizations appLocalizations;
  late AppProvider appProvider;
  late TabController tabController;
  late EventMapScreanProvider eventMapScreanProvider;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 8, vsync: this);
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  DateTime selectedDate = DateTime.now();
  DateTime time = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  TextEditingController titleController = TextEditingController();
  TextEditingController DescriptionController = TextEditingController();
  Categorydm selectedCategory = Categorydm.sports;

  @override
  Widget build(BuildContext context) {
    appProvider = context.appProvider;
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocaleProvider = Provider.of<AppLocaleProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;
    eventMapScreanProvider = Provider.of<EventMapScreanProvider>(context);

    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        appBar: AppBarView(
          title: appLocalizations.create_event,
          color: AppColors.primaryPurple,
        ),
        body: ListView(
          children: [
            buildImageView(context),
            Tabbarwidget(
              category: Categorydm.categorieswithOutAll,
              categoryClicked: (category) {
                selectedCategory = category;
                setState(() {});
              },
              tabController: tabController,
              inhome: false,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    appLocalizations.title,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.009,
                  ),
                  buildTitleFormField(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.015,
                  ),
                  Text(
                    appLocalizations.description,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.009,
                  ),
                  buildDescriptionFormField(),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.009,
                  ),
                  buildDateRow(context),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.009,
                  ),
                  buildTimeRow(context),
                  Text(
                    appLocalizations.location,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.009,
                  ),
                  InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => MapEventScrean(),
                          ),
                        );
                      },
                      child: buildChooseEventLocation(context)),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.01,
                  ),
                  builAddEventButton(context, selectedCategory),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  SizedBox builAddEventButton(
      BuildContext context, Categorydm selectedCategory) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.055,
      width: MediaQuery.of(context).size.width,
      child: FilledButton(
          onPressed: () async {
            EventDM event = EventDM(
                ownerId: appProvider.curentUser!.uid,
                title: titleController.text,
                category: selectedCategory.name,
                description: DescriptionController.text,
                date: selectedDate,
                time: time,
                lat: eventMapScreanProvider.currentLatLng?.latitude,
                long: eventMapScreanProvider.currentLatLng?.longitude);
            showLoading(context);
            await addEvent(event);
            hideLoading(context);
            Navigator.pop(context);
          },
          child: Text(appLocalizations.add_event)),
    );
  }

  Container buildChooseEventLocation(BuildContext context) {
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
          Image.asset(ImageAssets.location_selected),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
          Text(
            "${eventMapScreanProvider.currentLatLng?.latitude.round()},${eventMapScreanProvider.currentLatLng?.longitude.round()}",
            style: const TextStyle(
                fontSize: 16,
                color: AppColors.primaryPurple,
                fontWeight: FontWeight.bold),
          ),
          const Spacer(),
          const Icon(
            Icons.arrow_back_ios_outlined,
            color: AppColors.primaryPurple,
            textDirection: TextDirection.rtl,
          )
        ],
      ),
    );
  }

  Row buildTimeRow(BuildContext context) {
    return Row(
      children: [
        Icon(
          EvaIcons.calendar,
          color: themeProvider.isDark() ? AppColors.ofWhite : AppColors.black,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          '${time.hour}:${time.minute}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Spacer(),
        TextButton(
            onPressed: () async {
              selectedTime = (await showTimePicker(
                      context: context, initialTime: TimeOfDay.now()) ??
                  selectedTime);
              time = DateTime(selectedDate.year, selectedDate.month,
                  selectedDate.day, selectedTime.hour, selectedTime.minute);
              setState(() {});
            },
            child: Text(appLocalizations.event_time))
      ],
    );
  }

  Row buildDateRow(BuildContext context) {
    return Row(
      children: [
        Icon(
          EvaIcons.calendar,
          color: themeProvider.isDark() ? AppColors.ofWhite : AppColors.black,
        ),
        const SizedBox(
          width: 8,
        ),
        Text(
          '${selectedDate.day}/${selectedDate.month}/${selectedDate.year}',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const Spacer(),
        TextButton(
            onPressed: () async {
              selectedDate = (await showDatePicker(
                    context: context,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  ) ??
                  selectedDate);
              setState(() {});
            },
            child: Text(appLocalizations.choose_date))
      ],
    );
  }

  TextFormField buildDescriptionFormField() {
    return TextFormField(
      controller: DescriptionController,
      maxLines: 6,
      minLines: 3,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        hintText: appLocalizations.event_description,
        hintStyle: TextStyle(
            color: themeProvider.isDark() ? AppColors.ofWhite : AppColors.gray),
      ),
    );
  }

  TextFormField buildTitleFormField() {
    return TextFormField(
      controller: titleController,
      decoration: InputDecoration(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        prefixIcon: const Icon(
          EvaIcons.editOutline,
        ),
        hintText: appLocalizations.event_title,
        hintStyle: TextStyle(
            color: themeProvider.isDark() ? AppColors.ofWhite : AppColors.gray),
      ),
    );
  }

  SizedBox buildImageView(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.3,
      child: Stack(
        alignment: AlignmentDirectional.bottomStart,
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Container(
                width: MediaQuery.of(context).size.width * 0.94,
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
                    Text(selectedCategory.name,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.isDark()
                              ? AppColors.ofWhite
                              : AppColors.bgwhite,
                        )),
                    Image.asset(
                      selectedCategory.image,
                      width: MediaQuery.of(context).size.width * 0.4,
                      fit: BoxFit.cover,
                    ),
                  ],
                )),
          ),
        ],
      ),
    );
  }
}

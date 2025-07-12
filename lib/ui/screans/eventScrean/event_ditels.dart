import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:event_planning_app/core/models/eventDM.dart';
import 'package:event_planning_app/core/providers/map_screan_provider.dart';
import 'package:event_planning_app/ui/screans/eventScrean/edit_event_screan.dart';
import 'package:event_planning_app/utiles/provider_extintion.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';
import '../../../core/App_assets/image_assets.dart';
import '../../../core/firebasehulpers/store/firestore_hulpers.dart';
import '../../../core/models/categoryDm.dart';
import '../../../core/providers/app_local_provider.dart';
import '../../../core/providers/app_provider.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/themes/app_colors.dart';

class EventDitels extends StatefulWidget {
  EventDM event;

  EventDitels({super.key, required this.event});

  @override
  State<EventDitels> createState() => _EventDitelsState();
}

class _EventDitelsState extends State<EventDitels> {
  late ThemeProvider themeProvider;
  late AppLocaleProvider appLocaleProvider;
  late AppLocalizations appLocalizations;
  late AppProvider appProvider;
  late TabController tabController;


  @override
  Widget build(BuildContext context) {
    appProvider = context.appProvider;
    themeProvider = Provider.of<ThemeProvider>(context);
    appLocaleProvider = Provider.of<AppLocaleProvider>(context);
    appLocalizations = AppLocalizations.of(context)!;


    return Directionality(
      textDirection: TextDirection.ltr,
      child: Scaffold(
        backgroundColor: themeProvider.isDark()
            ? AppColors.bgDarkDarkPurple
            : AppColors.bgwhite,
        appBar: AppBar(
          centerTitle: true,
          leading: IconButton(
              onPressed: () {
                Navigator.pop(context);
              },
              icon: const Icon(
                Icons.arrow_back,
                color: AppColors.primaryPurple,
              )),
          backgroundColor: themeProvider.isDark()
              ? AppColors.bgDarkDarkPurple
              : AppColors.bgwhite,
          title: Text(
            appLocalizations.event_details,
            style: const TextStyle(color: AppColors.primaryPurple),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  if (appProvider.curentUser!.uid == widget.event.ownerId) {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              EditEventScrean(currentEvent: widget.event),
                        ));
                  } else {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                            backgroundColor: themeProvider.isDark()
                                ? AppColors.bgDarkDarkPurple
                                : AppColors.bgwhite,
                            title: const Text(
                              'Error',
                              style: TextStyle(color: AppColors.red),
                            ),
                            content: Text(
                              'You are not the owner of this event to make changes',
                              style: TextStyle(
                                color: themeProvider.isDark()
                                    ? AppColors.bgwhite
                                    : AppColors.primaryPurple,
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ]);
                      },
                    );
                  }
                },
                icon: const Icon(
                  EvaIcons.edit,
                  color: AppColors.primaryPurple,
                )),
            IconButton(
                onPressed: () async {
                  if (appProvider.curentUser!.uid == widget.event.ownerId) {
                    await deleteEvent(widget.event.id);
                    Navigator.pop(context);
                  } else {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (context) {
                        return AlertDialog(
                            backgroundColor: themeProvider.isDark()
                                ? AppColors.bgDarkDarkPurple
                                : AppColors.bgwhite,
                            title: const Text(
                              'Error',
                              style: TextStyle(color: AppColors.red),
                            ),
                            content: Text(
                              'You are not the owner of this event to make changes',
                              style: TextStyle(
                                color: themeProvider.isDark()
                                    ? AppColors.bgwhite
                                    : AppColors.primaryPurple,
                              ),
                            ),
                            actions: [
                              TextButton(
                                child: const Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                            ]);
                      },
                    );
                  }
                },
                icon: const Icon(
                  EvaIcons.trash2Outline,
                  color: AppColors.red,
                )),
          ],
        ),
        body: ListView(
          children: [
            buildImageView(context),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.event.title,
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.009,
                  ),
                  buildChooseEventTime(context),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.009,
                  ),
                  buildChooseEventLocation(context),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.009,
                  ),
                  Container(
                    height: MediaQuery.of(context).size.height * 0.3,
                    width: double.infinity,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppColors.primaryPurple)),
                    child: GoogleMap(
                      liteModeEnabled: true,
                      initialCameraPosition: CameraPosition(
                          target: LatLng(widget.event.lat!, widget.event.long!),
                          zoom: 17),
                      markers: {
                        Marker(
                          markerId: MarkerId("1"),
                          position:
                              LatLng(widget.event.lat!, widget.event.long!),
                        ),
                      },


                    ),
                  ),
                  SizedBox(
                    height: MediaQuery.of(context).size.height * 0.009,
                  ),
                  Text(
                    "Discrption\n${widget.event.description}",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
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
            appLocalizations.choose_event_location,
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

  buildChooseEventTime(BuildContext context) {
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
          Image.asset(ImageAssets.scadual),
          SizedBox(width: MediaQuery.of(context).size.width * 0.02),
          Text(
            "${widget.event.date.day}/${widget.event.date.month}/${widget.event.date.year}  \n${widget.event.time.hour}:${widget.event.time.minute}",
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
                    Text(Categorydm.fromName(widget.event.category).name,
                        style: TextStyle(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          color: themeProvider.isDark()
                              ? AppColors.ofWhite
                              : AppColors.bgwhite,
                        )),
                    Image.asset(
                      Categorydm.fromName(widget.event.category).image,
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

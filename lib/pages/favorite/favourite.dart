import 'package:evently_app/models/eventmodel.dart';
import 'package:evently_app/providers/event_provider.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/theme/apptheme.dart';
import 'package:evently_app/widgets/customtextfield.dart';
import 'package:evently_app/widgets/eventCard.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class Favourite extends StatefulWidget {
  const Favourite({super.key});

  @override
  State<Favourite> createState() => _FavouriteState();
}

class _FavouriteState extends State<Favourite> {
  List<Event> events = [];

  @override
  void initState() {
    super.initState();

    events = Provider.of<UserProvider>(context, listen: false)
        .filterEventsAccordingToFavourits(
      Provider.of<EventsProvider>(context, listen: false).events,
    );
  }

  void _updateEvents() {
    setState(() {
      events = Provider.of<UserProvider>(context, listen: false)
          .filterEventsAccordingToFavourits(
        Provider.of<EventsProvider>(context, listen: false).events,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              left: 16.0,
              right: 16,
              top: 10,
            ),
            child: CustomTextField(
              imagepath: 'assets/SVG/Icon Frame2.svg',
              hinttext: 'Search For Event',
              onChanged: (value) {},
              bordercolor: AppTheme.primary,
            ),
          ),
          SizedBox(
            height: 16,
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16.0,
              ),
              child: ListView.separated(
                  itemBuilder: (_, index) {
                    return index == events.length - 1
                        ? Column(
                            children: [
                              EventCard(
                                event: events[index],
                                onFavouriteChanged: _updateEvents,
                              ),
                              SizedBox(
                                height: 16,
                              )
                            ],
                          )
                        : EventCard(
                            event: events[index],
                            onFavouriteChanged: _updateEvents,
                          );
                  },
                  separatorBuilder: (_, index) {
                    return SizedBox(
                      height: 16,
                    );
                  },
                  itemCount: events.length),
            ),
          )
        ],
      ),
    );
  }
}

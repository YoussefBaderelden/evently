import 'package:evently_app/models/eventmodel.dart';
import 'package:evently_app/models/usermodel.dart';
import 'package:evently_app/providers/event_provider.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/theme/apptheme.dart';
import 'package:flutter/material.dart';
import 'package:geocode/geocode.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EventDetails extends StatefulWidget {
  const EventDetails({super.key});

  @override
  State<EventDetails> createState() => _EventDetailsState();
}

class _EventDetailsState extends State<EventDetails> {
  String? eventAddress;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Event event = ModalRoute.of(context)!.settings.arguments as Event;
      fetchEventAddress(event.lat!, event.long!);
    });
  }

  void fetchEventAddress(double lat, double long) async {
    String result = await getAddressFromLatLng(lat, long);
    setState(() {
      eventAddress = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    DateFormat selectedDateFormat = DateFormat('dd MMMM yyyy');
    DateFormat selectedTimeFormat = DateFormat('h:mm a');

    Event event = ModalRoute.settingsOf(context)!.arguments as Event;
    var screendim = MediaQuery.sizeOf(context);
    TextTheme texttheme = Theme.of(context).textTheme;
    UserModel? currentUser = Provider.of<UserProvider>(context).currnetUser;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppTheme.white,
        foregroundColor: AppTheme.primary,
        centerTitle: true,
        title: Text('Event Details'),
        actions: [
          currentUser!.id == event.userId
              ? Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.edit_calendar_rounded,
                        color: AppTheme.primary,
                        size: 22,
                      ),
                      onPressed: () {
                        Navigator.of(context)
                            .pushNamed('editevent', arguments: event);
                      },
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.delete_forever_outlined,
                        color: AppTheme.red,
                        size: 22,
                      ),
                      onPressed: () async {
                        bool confirmDelete = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Delete Event"),
                            content: Text(
                              "Are you sure you want to delete this event?",
                              style: texttheme.bodyLarge,
                            ),
                            actions: [
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: Text("Cancel"),
                              ),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(true),
                                child: Text("Delete",
                                    style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );

                        if (confirmDelete == true) {
                          await Provider.of<EventsProvider>(context,
                                  listen: false)
                              .deleteEvent(event.id);
                          Navigator.of(context)
                              .pop(); // Close event details screen
                        }
                      },
                    ),
                  ],
                )
              : SizedBox()
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: screendim.height * 0.235,
                child: Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(16),
                    child: Image.asset(
                      'assets/image/${event.category.imageName}.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                event.title,
                softWrap: true,
                style: texttheme.displaySmall?.copyWith(
                  color: AppTheme.primary,
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primary),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      style: IconButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: Icon(
                        Icons.date_range,
                      ),
                      color: AppTheme.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          selectedDateFormat.format(event.dateTime),
                          style: texttheme.bodyLarge?.copyWith(
                            color: AppTheme.primary,
                          ),
                        ),
                        Text(
                          selectedTimeFormat.format(event.dateTime),
                          style: texttheme.bodyLarge?.copyWith(
                            color: AppTheme.black,
                          ),
                        ),
                      ],
                    ),
                    Spacer(),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                padding: EdgeInsets.all(2),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primary),
                ),
                child: Row(
                  children: [
                    IconButton(
                      onPressed: () {},
                      style: IconButton.styleFrom(
                        backgroundColor: AppTheme.primary,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8)),
                      ),
                      icon: Icon(
                        Icons.my_location_rounded,
                      ),
                      color: AppTheme.white,
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Expanded(
                      child: Text(
                        eventAddress ?? 'Fetching location...',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: texttheme.bodyLarge?.copyWith(
                          color: AppTheme.primary,
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.keyboard_arrow_right_rounded,
                        color: AppTheme.primary,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(height: 16),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: AppTheme.primary),
                ),
                width: double.infinity,
                height: screendim.height * 0.4,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: GoogleMap(
                    mapType: MapType.normal,
                    scrollGesturesEnabled: false,
                    tiltGesturesEnabled: false,
                    zoomGesturesEnabled: false,
                    markers: {
                      Marker(
                        markerId: MarkerId('event_marker'),
                        position: LatLng(event.lat!, event.long!),
                      ),
                    },
                    initialCameraPosition: CameraPosition(
                      target: LatLng(event.lat!, event.long!),
                      zoom: 14,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              Text(
                'Description',
                softWrap: true,
                style: texttheme.bodyLarge?.copyWith(
                  color: AppTheme.black,
                ),
              ),
              SizedBox(height: 16),
              Text(
                event.describtion,
                softWrap: true,
                style: texttheme.bodyLarge?.copyWith(
                  color: AppTheme.black,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      GeoCode geoCode = GeoCode();

      Address address = await geoCode.reverseGeocoding(
          latitude: latitude, longitude: longitude);

      return " ${address.region ?? 'unknown'} , ${address.countryName ?? 'unknown'}";
    } catch (e) {
      return "Error retrieving address: $e";
    }
  }
}

import 'package:evently_app/models/category.dart';
import 'package:evently_app/models/eventmodel.dart';
import 'package:evently_app/pages/home/tabItem.dart';
import 'package:evently_app/providers/event_provider.dart';
import 'package:evently_app/providers/map_provider.dart';
import 'package:evently_app/providers/user_provider.dart';
import 'package:evently_app/services/firebaseServices.dart';
import 'package:evently_app/theme/apptheme.dart';
import 'package:evently_app/widgets/custombutton.dart';
import 'package:evently_app/widgets/customtextfield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:geocode/geocode.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CreateEvent extends StatefulWidget {
  const CreateEvent({super.key});

  @override
  State<CreateEvent> createState() => _CreateEventState();
}

class _CreateEventState extends State<CreateEvent> {
  LatLng? selectedLocation;
  String? eventAddress;

  int currrentindex = 0;
  Categoryy selectedCategory = Categoryy.categories.first;
  TextEditingController titleController = TextEditingController();
  TextEditingController describtionController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  DateFormat selectedDateFormat = DateFormat('dd/MM/yyyy');
  GlobalKey<FormState> formKey = GlobalKey<FormState>();

  void fetchAddress() async {
    if (selectedLocation != null) {
      String result = await getAddressFromLatLng(
        selectedLocation!.latitude,
        selectedLocation!.longitude,
      );

      setState(() {
        eventAddress = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    MapProvider mapProvider = Provider.of<MapProvider>(context);
    TextTheme texttheme = Theme.of(context).textTheme;
    var screendim = MediaQuery.sizeOf(context);

    if (mapProvider.choosedlocation != null &&
        mapProvider.choosedlocation != selectedLocation) {
      setState(() {
        selectedLocation = mapProvider.choosedlocation;
        eventAddress = null;
      });
      fetchAddress();
    }
    print("Updated selected location: $selectedLocation");

    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppTheme.primary,
        ),
        backgroundColor: AppTheme.white,
        centerTitle: true,
        title: Text(
          'Create Event',
          style: texttheme.displayMedium?.copyWith(
            color: AppTheme.primary,
          ),
        ),
      ),
      body: DefaultTabController(
        length: Categoryy.categories.length,
        child: Form(
          key: formKey,
          child: Padding(
            padding: const EdgeInsets.all(16),
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
                          'assets/image/${selectedCategory.imageName}.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TabBar(
                    tabAlignment: TabAlignment.start,
                    dividerColor: Colors.transparent,
                    indicatorColor: Colors.transparent,
                    labelPadding: EdgeInsets.only(right: 10),
                    isScrollable: true,
                    onTap: (index) {
                      currrentindex = index;
                      selectedCategory = Categoryy.categories[currrentindex];
                      setState(() {});
                    },
                    tabs: Categoryy.categories
                        .map(
                          (category) => TabItem(
                            selectedcolor: AppTheme.primary,
                            unselectedcolor: AppTheme.white,
                            icon: category.icon,
                            text: category.text,
                            isSelected: currrentindex ==
                                    Categoryy.categories.indexOf(category)
                                ? true
                                : false,
                          ),
                        )
                        .toList(),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'text',
                    style: texttheme.bodyLarge,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CustomTextField(
                    imagepath: 'assets/SVG/Note_Edit.svg',
                    hinttext: 'Event Title',
                    controller: titleController,
                    onChanged: (value) => titleController.text = value,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Event Title cannot be empty';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  Text(
                    'Description',
                    style: texttheme.bodyLarge,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CustomTextField(
                    maxlines: 5,
                    hinttext: 'Event Description',
                    controller: describtionController,
                    onChanged: (value) => describtionController.text = value,
                  ),
                  Row(
                    children: [
                      SvgPicture.asset('assets/SVG/Calendar_Days.svg'),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Event Date',
                        style: texttheme.bodyLarge,
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () async {
                          DateTime? date = await showDatePicker(
                            context: context,
                            initialDate: selectedDate,
                            initialEntryMode: DatePickerEntryMode.calendar,
                            firstDate: DateTime.now(),
                            lastDate: DateTime.now().add(
                              Duration(
                                days: 730,
                              ),
                            ),
                          );
                          if (date != null) {
                            setState(() {
                              selectedDate = date;
                            });
                          }
                        },
                        child: Text(
                          selectedDate == null
                              ? 'Choose Date'
                              : selectedDateFormat.format(selectedDate!),
                          style: texttheme.bodyLarge?.copyWith(
                            color: AppTheme.primary,
                          ),
                        ),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      SvgPicture.asset('assets/SVG/Clock.svg'),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        'Event Time',
                        style: texttheme.bodyLarge,
                      ),
                      Spacer(),
                      TextButton(
                        onPressed: () async {
                          TimeOfDay? time = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (time != null) {
                            setState(() {
                              selectedTime = time;
                            });
                          }
                        },
                        child: Text(
                          selectedTime == null
                              ? 'Choose Time'
                              : selectedTime!.format(context),
                          style: texttheme.bodyLarge?.copyWith(
                            color: AppTheme.primary,
                          ),
                        ),
                      )
                    ],
                  ),
                  Text(
                    'Location',
                    style: texttheme.bodyLarge,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  InkWell(
                    onTap: () {
                      Navigator.of(context).pushNamed('chooselocation');
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: AppTheme.primary),
                      ),
                      child: Row(
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('chooselocation');
                            },
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
                              selectedLocation == null
                                  ? 'Choose Event Location'
                                  : eventAddress ?? 'checking Location',

                              maxLines: 1,
                              style: texttheme.bodyLarge?.copyWith(
                                color: AppTheme.primary,
                              ),
                              // softWrap: true,
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('chooselocation');
                            },
                            icon: Icon(
                              Icons.keyboard_arrow_right_rounded,
                              color: AppTheme.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  CustomButton(
                    screendim: screendim,
                    text: 'Add Event',
                    onpressed: createEvent,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void createEvent() {
    final mapProvider = Provider.of<MapProvider>(context, listen: false);
    print(
        " Preparing to save event with location: ${mapProvider.choosedlocation}");

    if (formKey.currentState!.validate() &&
        selectedDate != null &&
        selectedTime != null &&
        Provider.of<MapProvider>(context, listen: false).choosedlocation !=
            null) {
      DateTime dateTime = DateTime(
        selectedDate!.year,
        selectedDate!.month,
        selectedDate!.day,
        selectedTime!.hour,
        selectedTime!.minute,
      );

      LatLng? chosenLocation =
          Provider.of<MapProvider>(context, listen: false).choosedlocation;

      if (chosenLocation == null) {
        Fluttertoast.showToast(msg: 'Please select a location for the event');
        return;
      }
      print(
          "Event Location: ${chosenLocation.latitude}, ${chosenLocation.longitude}");

      Event event = Event(
        title: titleController.text,
        userId:
            Provider.of<UserProvider>(context, listen: false).currnetUser!.id,
        describtion: describtionController.text,
        category: selectedCategory,
        dateTime: dateTime,
        lat: chosenLocation.latitude == 0 ? 30.1254 : chosenLocation.latitude,
        long: chosenLocation.longitude,
      );

      print(" Sending to Firestore: ${event.toJson()}");
      FireBaseServices.addEventsToFirestore(event).then((_) {
        print(" Event successfully saved in Firestore");
        Provider.of<EventsProvider>(context, listen: false)
            .getEventsToCategory();
        Navigator.of(context).pop();
      }).catchError(
        (error) {
          print(" Failed to save event: $error");
        },
      );
    } else {
      Fluttertoast.showToast(
        msg: 'the Event location is required',
        backgroundColor: AppTheme.white,
        textColor: AppTheme.primary,
        fontSize: 20,
      );
    }
  }

  Future<String> getAddressFromLatLng(double latitude, double longitude) async {
    try {
      GeoCode geoCode = GeoCode();

      Address address = await geoCode.reverseGeocoding(
          latitude: latitude, longitude: longitude);

      return " ${address.city ?? 'unknown'}, ${address.region ?? 'unknown'}, ${address.countryName ?? 'unknown'}";
    } catch (e) {
      return "Error retrieving address: $e";
    }
  }
}

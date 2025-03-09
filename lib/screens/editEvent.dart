import 'package:evently_app/models/category.dart';
import 'package:evently_app/models/eventmodel.dart';
import 'package:evently_app/pages/home/tabItem.dart';
import 'package:evently_app/providers/event_provider.dart';
import 'package:evently_app/providers/map_provider.dart';
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

class EditEvent extends StatefulWidget {
  const EditEvent({super.key});

  @override
  State<EditEvent> createState() => _EditEventState();
}

class _EditEventState extends State<EditEvent> {
  LatLng? selectedLocation;
  late Event event;
  String? eventAddress;
  String? neweventAddress;
  bool isAddressChanged = false;
  int currrentindex = 0;
  Categoryy selectedCategory = Categoryy.categories.first;
  TextEditingController titleController = TextEditingController();
  TextEditingController describtionController = TextEditingController();
  DateTime? selectedDate;
  TimeOfDay? selectedTime;
  DateFormat selectedDateFormat = DateFormat('dd/MM/yyyy');

  DateFormat selectedTimeFormat = DateFormat('h:mm a');
  GlobalKey<FormState> formKey = GlobalKey<FormState>();
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      event = ModalRoute.of(context)!.settings.arguments as Event;
      currrentindex = Categoryy.categories.indexOf(event.category);
      selectedCategory = event.category;
      titleController.text = event.title;
      describtionController.text = event.describtion;
      selectedDate = event.dateTime;
      selectedTime = TimeOfDay.fromDateTime(event.dateTime);

      fetchEventAddress(event.lat!, event.long!);
      setState(() {});
    });

    super.initState();
  }

  void fetchEventAddress(double latitude, double longitude) async {
    String result = await getAddressFromLatLng(latitude, longitude);
    setState(() {
      eventAddress = result;
    });
  }

  void fetchAddressByEditedData() async {
    if (selectedLocation != null) {
      String result = await getAddressFromLatLng(
        selectedLocation!.latitude,
        selectedLocation!.longitude,
      );

      setState(() {
        neweventAddress = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    event = ModalRoute.settingsOf(context)!.arguments as Event;

    TextTheme texttheme = Theme.of(context).textTheme;
    MapProvider mapProvider = Provider.of<MapProvider>(context);

    if (mapProvider.choosedlocation != null &&
        mapProvider.choosedlocation != selectedLocation) {
      setState(() {
        selectedLocation = mapProvider.choosedlocation;
        neweventAddress = null;
      });
      fetchAddressByEditedData();
    }

    var screendim = MediaQuery.sizeOf(context);
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: AppTheme.primary,
        ),
        backgroundColor: AppTheme.white,
        centerTitle: true,
        title: Text(
          'Edit Event',
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
                    'Title',
                    style: texttheme.bodyLarge,
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  CustomTextField(
                    imagepath: 'assets/SVG/Note_Edit.svg',
                    hinttext: event.title,
                    controller: titleController,
                    onChanged: (value) => titleController.text = value,
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
                    hinttext: event.describtion.isEmpty
                        ? 'No description'
                        : event.describtion,
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
                              ? selectedDateFormat.format(event.dateTime)
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
                              ? selectedTimeFormat.format(event.dateTime)
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
                      isAddressChanged = true;
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
                              isAddressChanged = true;
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
                              isAddressChanged
                                  ? neweventAddress ?? 'Fetching address...'
                                  : eventAddress ?? 'Fetching address...',
                              maxLines: 3,
                              style: texttheme.bodyLarge?.copyWith(
                                color: AppTheme.primary,
                              ),
                            ),
                          ),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).pushNamed('chooselocation');
                              isAddressChanged = true;
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
                    text: 'Update Event',
                    onpressed: updateEvent,
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

  void updateEvent() {
    if (formKey.currentState!.validate() &&
        selectedDate != null &&
        selectedTime != null) {
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
      Event updatedEvent = Event(
        id: event.id,
        title:
            titleController.text.isEmpty ? event.title : titleController.text,
        userId: event.userId,
        describtion: describtionController.text.isEmpty
            ? event.describtion
            : describtionController.text,
        category: selectedCategory,
        dateTime: dateTime,
        lat: isAddressChanged ? chosenLocation.latitude : event.lat,
        long: isAddressChanged ? chosenLocation.longitude : event.long,
      );
      print(isAddressChanged);

      FireBaseServices.updateEventInFirestore(updatedEvent).then((_) {
        Provider.of<EventsProvider>(context, listen: false)
            .getEventsToCategory();
        Navigator.pushNamedAndRemoveUntil(
          context,
          'details',
          arguments: updatedEvent,
          ModalRoute.withName('home'),
        ); // Keeps '/login' in the stack)
      }).catchError(
        (_) => print('Failed to update event'),
      );
    }
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

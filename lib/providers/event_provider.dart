import 'package:evently_app/models/category.dart';
import 'package:evently_app/models/eventmodel.dart';
import 'package:evently_app/services/firebaseServices.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

class EventsProvider with ChangeNotifier {
  List<Event> events = [];
  List<Event> allevents = [];
  Categoryy? selectedCategory;

  Future<void> getEventsToCategory() async {
    events =
        await FireBaseServices.getAllEventsFromFirestore(selectedCategory?.id);
    notifyListeners();
  }

  Future<List<Event>> getAllEvents() async {
    allevents =
        await FireBaseServices.getAllEventsFromFirestore(selectedCategory?.id);
    notifyListeners();
    return events;
  }

  void changeSelectedCategory(Categoryy? category) {
    selectedCategory = category;
    getEventsToCategory();
  }

  EventsProvider() {
    listenToEvents();
  }

  void listenToEvents() {
    FireBaseServices.getEventStream().listen((updatedEvents) {
      events = updatedEvents;
      notifyListeners();
    });
  }

  Future<void> deleteEvent(String eventId) async {
    await FireBaseServices.deleteEventFromFirestore(eventId);
    events.removeWhere((event) => event.id == eventId);
    notifyListeners();
  }
}

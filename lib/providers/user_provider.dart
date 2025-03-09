import 'package:evently_app/models/eventmodel.dart';
import 'package:evently_app/models/usermodel.dart';
import 'package:evently_app/services/firebaseServices.dart';
import 'package:flutter/material.dart';

class UserProvider with ChangeNotifier {
  UserModel? currnetUser;

  void updateCurrentUser(UserModel? user) {
    currnetUser = user;
    notifyListeners();
  }

  bool checkIfEventIsFavourite(String eventId) {
    return currnetUser!.favourits.any(
      (favouriteId) => favouriteId == eventId,
    );
  }

  void addToFavourits(String userId) {
    FireBaseServices.addToEventToFavourits(userId);
    currnetUser!.favourits.add(userId);
    notifyListeners();
  }

  void removeFromFavourits(String userId) {
    FireBaseServices.removwEventFromFavourits(userId);
    currnetUser!.favourits.remove(userId);
    notifyListeners();
  }

  List<Event> filterEventsAccordingToFavourits(List<Event> events) {
    List<Event> filteredEvents = events
        .where(
          (event) => currnetUser!.favourits.contains(
            event.id,
          ),
        )
        .toList();

    return filteredEvents;
  }
}

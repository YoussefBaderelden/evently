import 'package:event_planning_app/core/models/userDM.dart';
import 'package:flutter/material.dart';
import '../firebasehulpers/store/firestore_hulpers.dart';

class AppProvider extends ChangeNotifier {
   Userdm ? curentUser;

  updateUser(Userdm newUser) {
    curentUser = newUser;
    notifyListeners();
  }

  addToFavouriteEvent(String eventId) async {
    await  addEventToFav(eventId,curentUser!.uid);
    curentUser = await getUserfromFirestore(curentUser!.uid);
    notifyListeners();
  }

  removeFromFavouriteEvent(String eventId) async {
   await deleteEventFromFav(eventId,curentUser!.uid);
    curentUser = await getUserfromFirestore(curentUser!.uid);
    notifyListeners();
  }
}

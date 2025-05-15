import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:event_planning_app/core/models/eventDM.dart';
import 'package:event_planning_app/core/models/userDM.dart';

//todo: for users
Future<void> addUserToFirestore(Userdm userDm) async {
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  user.doc(userDm.uid).set(userDm.toJson());
}

Future<Userdm> getUserfromFirestore(String uid) async {
  CollectionReference user = FirebaseFirestore.instance.collection('users');
  var doc = user.doc(uid);
  DocumentSnapshot SnapShot = await doc.get();
  Map<String, dynamic> data = SnapShot.data() as Map<String, dynamic>;
  return Userdm.fromJson(json: data);
}

//todo:for events
Future<void> addEvent(EventDM event) async {
  CollectionReference Event = FirebaseFirestore.instance.collection('Events');
  Event.add(event.toJson());
}

Future<List<EventDM>> getEventsByCategory(String category) async {
  if (category == 'All') {
    CollectionReference Events =
        FirebaseFirestore.instance.collection('Events');
    QuerySnapshot querySnapshot = await Events.get();
    List<QueryDocumentSnapshot<Object?>> documentsList = querySnapshot.docs;

    List<EventDM> events = documentsList
        .map((e) => EventDM.fromJson(e.data() as Map<String, dynamic>))
        .toList();
    return events;
  } else {
    CollectionReference Events =
        FirebaseFirestore.instance.collection('Events');
    QuerySnapshot querySnapshot =
        await Events.where('category', isEqualTo: category).get();
    List<QueryDocumentSnapshot<Object?>> documentsList = querySnapshot.docs;

    List<EventDM> events = documentsList
        .map((e) => EventDM.fromJson(e.data() as Map<String, dynamic>))
        .toList();
    return events;
  }
}

Future<void> deleteEventFromFav() async {}

Future<void> updateEvent() async {}

Future<void> addEventToFav() async {}

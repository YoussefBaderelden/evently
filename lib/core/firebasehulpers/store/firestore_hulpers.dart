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
  DocumentSnapshot snapshot = await doc.get();

  if (!snapshot.exists || snapshot.data() == null) {
    throw Exception('User with uid $uid not found in Firestore');
  }

  Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
  Userdm userDM = Userdm.fromJson(json: data);
  return userDM;
}

//todo:for events
Future<void> addEvent(EventDM event) async {
  CollectionReference Event = FirebaseFirestore.instance.collection('Events');
  Event.add(event.toJson());
}

Stream<List<EventDM>> getEventsByCategory(String category) {
  if (category == 'All') {
    CollectionReference Events =
        FirebaseFirestore.instance.collection('Events');
    Stream<QuerySnapshot> querySnapshot = Events.snapshots();
    Stream<List<EventDM>> eventStream = querySnapshot.map((querySnapshot) {
      List<QueryDocumentSnapshot<Object?>> documentsList = querySnapshot.docs;
      List<EventDM> events = documentsList.map(ToEventList).toList();
      return events;
    });
    return eventStream;
  } else {
    CollectionReference Events =
        FirebaseFirestore.instance.collection('Events');
    Stream<QuerySnapshot> querySnapshot =
        Events.where('category', isEqualTo: category).snapshots();

    Stream<List<EventDM>> eventStream = querySnapshot.map((querySnapshot) {
      List<QueryDocumentSnapshot<Object?>> documentsList = querySnapshot.docs;
      List<EventDM> events = documentsList.map(ToEventList).toList();
      return events;
    });
    return eventStream;
  }
}

Future<List<EventDM>> getFavEvents(Userdm user) async {
  List<String> favEvents = user.addEventToFav;
  CollectionReference Events = FirebaseFirestore.instance.collection('Events');
  if (favEvents.isEmpty) {
    return [];
  }
  QuerySnapshot querySnapshot =
      await Events.where(FieldPath.documentId, whereIn: favEvents).get();
  var Favevents = querySnapshot.docs;
  return Favevents.map(ToEventList).toList();
}

EventDM ToEventList(e) =>
    EventDM.fromJson(e.data() as Map<String, dynamic>, id: e.id);

Future<void> deleteEventFromFav(String eventId, String uid) async {
  var user = FirebaseFirestore.instance.collection('users');
  var userDoc = user.doc(uid);
  userDoc.update({
    "addEventToFav": FieldValue.arrayRemove([eventId])
  });
}

Future<void> deleteEvent(String eventId) async {
  CollectionReference event = FirebaseFirestore.instance.collection('Events');
  event.doc(eventId).delete();
}

Future<void> updateEvent(EventDM event) async {
  CollectionReference eventRef =
  FirebaseFirestore.instance.collection('Events');

  await eventRef.doc(event.id).update({
    "category": event.category,
    "title": event.title,
    "description": event.description,
    "date": event.date,
    "time": event.time,
    "lat": event.lat,
    "long": event.long
  });
}

Future<void> addEventToFav(String eventId, String uid) async {
  var user = FirebaseFirestore.instance.collection('users');
  var userDoc = user.doc(uid);
  userDoc.update({
    "addEventToFav": FieldValue.arrayUnion([eventId])
  });
}

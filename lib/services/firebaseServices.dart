import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_app/models/eventmodel.dart';
import 'package:evently_app/models/usermodel.dart';

import 'package:firebase_auth/firebase_auth.dart';

class FireBaseServices {
  static CollectionReference<Event> getEventCollection() =>
      FirebaseFirestore.instance.collection('events').withConverter<Event>(
            fromFirestore: (docSnapshot, _) =>
                Event.fromJson(docSnapshot.data()!),
            toFirestore: (event, _) => event.toJson(),
          );

  static CollectionReference<UserModel> getUserCollection() =>
      FirebaseFirestore.instance.collection('users').withConverter<UserModel>(
            fromFirestore: (docSnapshot, _) =>
                UserModel.fromJson(docSnapshot.data()!),
            toFirestore: (user, _) => user.toJson(),
          );
  static Future<void> addEventsToFirestore(Event event) async {
    print("🔥 Writing event to Firestore: ${event.toJson()}");
    CollectionReference<Event> eventsCollection = getEventCollection();
    DocumentReference<Event> doc = eventsCollection.doc();
    event.id = doc.id;
    print("✅ Event saved successfully!");
    return doc.set(event);
  }

  static Future<List<Event>> getAllEventsFromFirestore(String? id) async {
    CollectionReference<Event> eventsCollection = getEventCollection();
    late QuerySnapshot<Event> snapshot;
    if (id != null) {
      snapshot = await eventsCollection
          .where('category', isEqualTo: id)
          .orderBy('date')
          .get();
    } else {
      snapshot = await eventsCollection.orderBy('date').get();
    }

    List<Event> events = snapshot.docs.map((doc) => doc.data()).toList();

    return events;
  }

  static Future<UserModel> register({
    required String name,
    required String password,
    required String email,
  }) async {
    UserCredential credentials =
        await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );

    UserModel user = UserModel(
      id: credentials.user!.uid,
      name: name,
      email: email,
      favourits: [],
    );

    CollectionReference<UserModel> userCollection = getUserCollection();
    await userCollection.doc(user.id).set(user);
    return user;
  }

  static Future<UserModel> login({
    required String email,
    required String password,
  }) async {
    UserCredential credentials = await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email, password: password);

    CollectionReference<UserModel> userCollection = getUserCollection();
    DocumentSnapshot<UserModel> docSnapshot =
        await userCollection.doc(credentials.user!.uid).get();
    UserModel? user = docSnapshot.data()!;

    return user;
  }

  static Future<void> logout() => FirebaseAuth.instance.signOut();

  static addToEventToFavourits(String eventId) {
    CollectionReference<UserModel> userCollection = getUserCollection();
    userCollection
        .doc(
      FirebaseAuth.instance.currentUser!.uid,
    )
        .update(
      {
        'favourits': FieldValue.arrayUnion(
          [
            eventId,
          ],
        )
      },
    );
  }

  static removwEventFromFavourits(String eventId) {
    CollectionReference<UserModel> userCollection = getUserCollection();
    userCollection
        .doc(
      FirebaseAuth.instance.currentUser!.uid,
    )
        .update(
      {
        'favourits': FieldValue.arrayRemove(
          [
            eventId,
          ],
        )
      },
    );
  }

  static Stream<List<Event>> getEventStream() {
    return getEventCollection().snapshots().map((snapshot) {
      return snapshot.docs.map((doc) => doc.data()).toList();
    });
  }

  static Future<void> updateEventInFirestore(Event event) async {
    CollectionReference<Event> eventsCollection = getEventCollection();
    await eventsCollection.doc(event.id).update(event.toJson());
  }

  static Future<void> deleteEventFromFirestore(String eventId) async {
    try {
      await getEventCollection().doc(eventId).delete();
      print(" Event deleted successfully!");
    } catch (e) {
      print(" Error deleting event: $e");
    }
  }
}

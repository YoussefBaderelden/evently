import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:evently_app/models/category.dart';

class Event {
  String id;
  String userId;
  String title;
  String describtion;
  Categoryy category;
  DateTime dateTime;
  double? lat;
  double? long;

  Event({
    this.id = '',
    required this.title,
    required this.describtion,
    required this.category,
    required this.dateTime,
    required this.userId,
    this.lat = 0,
    this.long = 0,
  });

  void update({
    String? title,
    String? describtion,
    Categoryy? category,
    DateTime? dateTime,
    double? lat,
    double? long,
  }) {
    this.title = title ?? this.title;
    this.describtion = describtion ?? this.describtion;
    this.category = category ?? this.category;
    this.dateTime = dateTime ?? this.dateTime;
    this.lat = lat ?? this.lat;
    this.long = long ?? this.long;
  }

  Event.fromJson(Map<String, dynamic> json)
      : this(
          userId: json['userId'],
          id: json['id'],
          title: json['title'],
          describtion: json['description'],
          category: Categoryy.categories
              .firstWhere((Category) => Category.id == json['category']),
          dateTime: (json['date'] as Timestamp).toDate(),
          lat: json['lat'] ?? 0,
          long: json['long'] ?? 0,
        );

  Map<String, dynamic> toJson() => {
        'userId': userId,
        'id': id,
        'title': title,
        'description': describtion,
        'category': category.id,
        'date': Timestamp.fromDate(dateTime),
        'lat': lat,
        'long': long,
      };
}

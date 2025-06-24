class EventDM {
 late String id;
 late  String title;
 late String category;
 late  String description;
 late DateTime date;
 late DateTime time;
 late int? lat;
 late int? long;
 late String ownerId;

  EventDM(
      {
      required this.title,
      required this.category,
      required this.description,
      required this.date,
      required this.ownerId,
        required this.time,
      this.lat,
      this.long});
  EventDM.fromJson(Map<String, dynamic> json, {this.id = ""}) {
    title = json['title'];
    category = json['category'];
    description = json['description'];
    date = json['date'].toDate();
    time = json['time'].toDate();
    ownerId = json['ownerId'];
    lat = json['lat'];
    long = json['long'];
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'category': category,
      'description': description,
      'date': date,
      'time': time,
      'ownerId': ownerId,
      'lat': lat,
      'long': long
    };
  }
}

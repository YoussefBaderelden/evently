class Userdm {
  late String uid;
  late String email;
  late String name;
  late List<String> addEventToFav;

  Userdm({
    required this.uid,
    required this.email,
    required this.name,
    this.addEventToFav = const [],
  });

  Userdm.fromJson({required Map<String, dynamic> json}) {
    uid = json['uid'];
    email = json['email'];
    name = json['name'];
    print('10000 ${json['addEventToFav']}');
    List<dynamic>? list = json['addEventToFav'] as List<dynamic>?;
    addEventToFav = list?.map((e) => e.trim().toString().trim()).toList() ?? [];
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'addEventToFav': addEventToFav,
    };
  }

  static Userdm currentUser = Userdm(uid: '', email: '', name: '', addEventToFav: []);

  bool isfavouriteevent(String eventId) {
    return addEventToFav.contains(eventId);
  }
}
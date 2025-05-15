class Userdm {
  late String uid;
  late String email;
  late String name;
  late List<String>? addEventToFav;

  Userdm({required this.uid, required this.email, required this.name,this.addEventToFav});

  Userdm.fromJson({required Map<String, dynamic> json}) {
    uid = json['uid'];
    email = json['email'];
    name = json['name'];
    addEventToFav = json['addEventToFav'];
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'addEventToFav': addEventToFav
    };
  }
  static Userdm currentUser = Userdm(uid: '', email: '', name: '');
}

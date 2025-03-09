class UserModel {
  String id;
  String name;
  String email;
  List<String> favourits = [];

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.favourits,
  });

  UserModel.fromJson(Map<String, dynamic> json)
      : this(
          id: json['id'],
          name: json['name'],
          email: json['email'],
          favourits: (json['favourits'] as List).cast<String>(),
        );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'email': email,
        'favourits': favourits,
      };
}

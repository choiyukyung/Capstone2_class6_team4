class User {
  String? id;
  String? password;
  String? name;
  String? birthdate;

  User({
    required this.id,
    required this.password,
    required this.name,
    required this.birthdate
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'],
        password: json['password'],
        name: json['name'],
        birthdate: json['birthday'],
    );
  }
  Map<String, dynamic> toJson() => {
    'id': id,
    'password': password,
    'name': name,
    'birthdate': birthdate,
  };
}
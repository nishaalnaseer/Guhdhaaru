class User {
  int id;
  String name;
  String email;
  String? password;
  bool isAdmin;
  bool enabled;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.isAdmin,
    required this.enabled,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json["id"],
        name: json["name"],
        email: json["email"],
        password: json["password"],
        isAdmin: json["is_admin"],
        enabled: json["enabled"],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "name": name,
      "email": email,
      "password": password,
      "is_admin": isAdmin,
      "enabled": enabled,
    };
  }
}

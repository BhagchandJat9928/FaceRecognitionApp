class User {
  final String id;
  final String name;
  final String email;
  final bool isActive;

  User(this.id, this.name, this.email, this.isActive);

  Map<String, dynamic> toJson(User user) {
    return {
      "id": user.id,
      "name": user.name,
      "email": user.email,
      "active": user.isActive
    };
  }

  factory User.fromJson(dynamic json) {
    return User(json["id"] as String, json["name"] as String,
        json["email"] as String, json["active"] as bool);
  }

  @override
  String toString() {
    return 'User{id: $id, name: $name, email: $email, isActive: $isActive}';
  }
}

class User {
  late String imagePath;
  late String name;
  late String email;
  late String phone;
  late List<String> registeredChallengeIDs;

  User(
    this.imagePath,
    this.name,
    this.email,
    this.phone,
    this.registeredChallengeIDs,
  );
  User.fromMap(dynamic obj) {
    imagePath = obj['imagePath'];
    name = obj['name'];
    email = obj['email'];
    phone = obj['phone'];
    registeredChallengeIDs = obj['registeredChallengeIDs'];
  }

  Map<String, dynamic> toMap() => {
        'imagePath': imagePath,
        'name': name,
        'email': email,
        'phone': phone,
        "registeredChallengeIDs": registeredChallengeIDs,
      };
}

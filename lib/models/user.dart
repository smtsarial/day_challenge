class User {
  late String id;
  late String imagePath;
  late String fname;
  late String lname;
  late String email;
  late String phone;
  late List registeredChallengeIDs;

  User(
    this.id,
    this.imagePath,
    this.fname,
    this.lname,
    this.email,
    this.phone,
    this.registeredChallengeIDs,
  );
  User.fromMap(dynamic obj) {
    imagePath = obj['imagePath'] ?? " ";
    fname = obj['fname'] ?? " ";
    lname = obj['lname'] ?? " ";
    email = obj['email'] ?? " ";
    phone = obj['phone'] ?? " ";
    registeredChallengeIDs = obj['registeredChallengeIDs'] ?? [];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['imagePath'] = this.imagePath;
      map['fname'] = this.fname;
      map['lname'] = this.lname;
      map['email'] = this.email;
      map['phone'] = this.phone;
      map["registeredChallengeIDs"] = this.registeredChallengeIDs;
    }
    return map;
  }
}

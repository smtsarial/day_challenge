class ChallengeDetail {
  late String id;
  late String author_fname;
  late String author_lname;
  late String challenge_description;
  late int star;
  late String author_mail;
  late String challenge_name;
  late String type;

  ChallengeDetail(
      this.id,
      this.author_fname,
      this.author_lname,
      this.author_mail,
      this.star,
      this.challenge_description,
      this.challenge_name,
      this.type);

  ChallengeDetail.fromMap(dynamic obj) {
    author_fname = obj['author_fname'] ?? " ";

    type = obj['type'] ?? " ";
    author_lname = obj['author_lname'] ?? " ";
    author_mail = obj['author_mail'] ?? " ";
    challenge_name = obj['challenge_name'] ?? " ";
    challenge_description = obj['challenge_description'] ?? " ";
    star = obj['star'] ?? 0;
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['type'] = this.type;
      map['author_fname'] = this.author_fname;
      map['author_lname'] = this.author_lname;
      map['author_mail'] = this.author_mail;
      map['challenge_name'] = this.challenge_name;
      map['challenge_description'] = this.challenge_description;
      map['star'] = this.star;
    }
    return map;
  }
}

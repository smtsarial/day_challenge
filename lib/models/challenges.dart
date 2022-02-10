class ChallengeDetail {
  late String id;
  late String author_fname;
  late String author_lname;
  late int registeredUserCount;
  late int star;
  late String author_mail;
  late String challenge_name;
  late List day_challenge;

  ChallengeDetail(
      this.id,
      this.author_fname,
      this.author_lname,
      this.author_mail,
      this.star,
      this.registeredUserCount,
      this.day_challenge,
      this.challenge_name);

  ChallengeDetail.fromMap(dynamic obj) {
    author_fname = obj['author_fname'];
    author_lname = obj['author_lname'];
    author_mail = obj['author_mail'];
    challenge_name = obj['challenge_name'];
    day_challenge = obj['day_challenge'];

    registeredUserCount = obj['registeredUserCount'];
    star = obj['star'];
  }

  Map<String, dynamic> toMap() {
    var map = Map<String, dynamic>();
    if (id != null) {
      map['author_fname'] = this.author_fname;
      map['author_lname'] = this.author_lname;
      map['author_mail'] = this.author_mail;
      map['challenge_name'] = this.challenge_name;
      map['day_challenge'] = this.day_challenge;
      map['registeredUserCount'] = this.registeredUserCount;
      map['star'] = this.star;
    }
    return map;
  }
}

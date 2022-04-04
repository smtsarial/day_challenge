import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_challenge/db/auth.dart';
import 'package:day_challenge/models/challenges.dart';
import 'package:day_challenge/models/dailyChallenges.dart';
import 'package:day_challenge/models/user.dart';

class FirestoreHelper {
  static final FirebaseFirestore db = FirebaseFirestore.instance;
  /****** ADD NEW USER */
  static Future addNewUser(fname, lname, email, phone) {
    var result = db.collection('users').add(User(
        "",
        "https://firebasestorage.googleapis.com/v0/b/day-challenge-e7c87.appspot.com/o/test%2Fphoto.png?alt=media&token=c0b743a9-55f7-41ec-86ac-df857a419307",
        fname,
        lname,
        email,
        phone, []).toMap());
    return result;
  }

  static Future<User> getUserData(userMail) async {
    var returnValue;
    var data =
        await db.collection('users').where("email", isEqualTo: userMail).get();

    List<User> details = [];

    if (data != null) {
      details = data.docs.map((document) => User.fromMap(document)).toList();
    }
    int i = 0;
    details.forEach((detail) {
      detail.id = data.docs[i].id;
      i++;
    });

    return details[0];
  }

  static Future userRegistedChallenge(email, challengeID) async {
    try {
      await db
          .collection('users')
          .where("email", isEqualTo: email)
          .get()
          .then((value) async => {
                await db.collection("users").doc(value.docs[0].id).update({
                  "registeredChallengeIDs": FieldValue.arrayUnion([challengeID])
                })
              });
    } catch (e) {
      print(e);
      return e;
    }
  }

  static Future userUNRegistedChallenge(email, challengeID) async {
    try {
      await db
          .collection('users')
          .where("email", isEqualTo: email)
          .get()
          .then((value) async => {
                await db.collection("users").doc(value.docs[0].id).update({
                  "registeredChallengeIDs":
                      FieldValue.arrayRemove([challengeID])
                })
              });
    } catch (e) {
      print(e);
      return e;
    }
  }

  static Future<List<ChallengeDetail>> getFavoriteChallenges(email) async {
    try {
      List<dynamic> favorite = [];
      List<ChallengeDetail> favoriteChallenges = [];
      await db
          .collection('users')
          .where("email", isEqualTo: email)
          .get()
          .then((value) async => {
                await db.collection("users").doc(value.docs[0].id).get().then(
                    (value) =>
                        value['registeredChallengeIDs'].forEach((detail) {
                          favorite.add(detail);
                        }))
              });

      for (int i = 0; i < favorite.length; i++) {
        await db
            .collection('challenges')
            .doc(favorite[i])
            .get()
            .then((DocumentSnapshot documentSnapshot) {
          if (documentSnapshot.exists) {
            favoriteChallenges
                .add(ChallengeDetail.fromMap(documentSnapshot.data()));
          } else {
            favorite.remove(favorite[i]);
            print('Document does not exist on the database');
          }
        });
      }
      for (int i = 0; i < favorite.length; i++) {
        favoriteChallenges[i].id = favorite[i];
      }

      return favoriteChallenges;
    } catch (e) {
      print(e);

      List<ChallengeDetail> favoriteChallenges = [];
      return favoriteChallenges;
    }
  }

  static Future<List<ChallengeDetail>> getMyChallenges(email) async {
    List<ChallengeDetail> details = [];
    try {
      var data = await db
          .collection("challenges")
          .where("author_mail", isEqualTo: email)
          .get();
      if (data != null) {
        details = data.docs
            .map((document) => ChallengeDetail.fromMap(document))
            .toList();
      }
      int i = 0;
      details.forEach((detail) {
        detail.id = data.docs[i].id;
        i++;
      });
      return details;
    } catch (e) {
      print(e);
      return details;
    }
  }

  /****** END ADD NEW USER */
  /**** GET DATA CHALLENGES */
  static Future<List<ChallengeDetail>> getDetailsList() async {
    List<ChallengeDetail> details = [];
    var data = await db.collection('challenges').get();

    if (data != null) {
      details = data.docs
          .map((document) => ChallengeDetail.fromMap(document))
          .toList();
    }
    int i = 0;
    details.forEach((detail) {
      detail.id = data.docs[i].id;
      i++;
    });

    return details;
  }

  static Future<ChallengeDetail> getSpecificChallenge(String id) async {
    late ChallengeDetail detailData;
    var data = await db
        .collection('challenges')
        .doc(id)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        detailData = ChallengeDetail.fromMap(documentSnapshot.data());
      } else {
        print('Document does not exist on the database');
      }
    });
    return detailData;
  }

  static Future addNewEvent(ChallengeDetail eventDetail) {
    var result = db
        .collection('challenges')
        .add(eventDetail.toMap())
        .then((value) => print(value))
        .catchError((error) => print(error));
    return result;
  }

  static Future<List<ChallengeDetail>> deleteEvent(String documentId) async {
    await db.collection('challenges').doc(documentId).delete();
    return getDetailsList();
  }

  static Future<List<ChallengeDetail>> findMyChallenges() async {
    dynamic challenges = await db.collection("challenges").where("author_mail");
    return challenges;
  }

  /**** END GET DATA CHALLENGES */

  /********* REFERANCE ISSUES */
  static Future<bool> checkUserSubscribeOrNot(challengeID, userMail) async {
    bool data = await db
        .collection('challenges')
        .doc(challengeID)
        .collection("signed")
        .where("mail", isEqualTo: userMail)
        .get()
        .then((value) {
      if (value.size != 0) {
        return true;
      } else {
        return false;
      }
    });
    return data;
  }

  static Future<bool> registerChallenge(challengeID, userMail) async {
    try {
      await db
          .collection('challenges')
          .doc(challengeID)
          .collection("signed")
          .add({"mail": userMail, "date": DateTime.now()});

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> unregisterChallenge(challengeID, userMail) async {
    List<String> registeredMailList = [];
    try {
      await db
          .collection('challenges')
          .doc(challengeID)
          .collection("signed")
          .where("mail", isEqualTo: userMail)
          .get()
          .then((value) => {
                for (int i = 0; i < value.size; i++)
                  {registeredMailList.add(value.docs[i].id)}
              });

      for (int i = 0; i < registeredMailList.length; i++) {
        await db
            .collection('challenges')
            .doc(challengeID)
            .collection('signed')
            .doc(registeredMailList[i])
            .delete();
      }
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

//// UPDATE OPERATIONS
  static Future<bool> updateMainChallenge(challengeId, data) async {
    try {
      await db.collection('challenges').doc(challengeId).update(data);

      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<DailyChallenge> updateDayTask(
      challengeId, dayID, addValue) async {
    late DailyChallenge detailData;
    await db
        .collection('challenges')
        .doc(challengeId)
        .collection('daily_challenges')
        .doc(dayID)
        .update({
      "daily_tasks": FieldValue.arrayUnion([addValue])
    }).catchError((error) => print('Update failed: $error'));

    await db
        .collection('challenges')
        .doc(challengeId)
        .collection('daily_challenges')
        .doc(dayID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        detailData = DailyChallenge.fromMap(documentSnapshot.data());
      } else {
        print('Document does not exist on the database');
      }
    });
    return detailData;
  }

  static Future<DailyChallenge> deleteDayTask(
      challengeId, dayID, deleteValue) async {
    late DailyChallenge detailData;
    await db
        .collection('challenges')
        .doc(challengeId)
        .collection('daily_challenges')
        .doc(dayID)
        .update({
      "daily_tasks": FieldValue.arrayRemove([deleteValue])
    }).catchError((error) => print('Update failed: $error'));

    await db
        .collection('challenges')
        .doc(challengeId)
        .collection('daily_challenges')
        .doc(dayID)
        .get()
        .then((DocumentSnapshot documentSnapshot) {
      if (documentSnapshot.exists) {
        detailData = DailyChallenge.fromMap(documentSnapshot.data());
      } else {
        print('Document does not exist on the database');
      }
    });
    return detailData;
  }

  static Future<bool> updateDailyChallengeTopic(
      value, challengeID, dayID) async {
    try {
      await db
          .collection('challenges')
          .doc(challengeID)
          .collection("daily_challenges")
          .doc(dayID)
          .update({"day_topic": value});
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> completeDayTasks(challengeID, dayID) async {
    try {
      await Authentication().getUser().then((value) async {
        await db
            .collection('challenges')
            .doc(challengeID)
            .collection('daily_challenges')
            .doc(dayID)
            .update({
          "completed_users": FieldValue.arrayUnion([
            {value: DateTime.now()}
          ])
        });
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> removeDayTasks(challengeID, dayID) async {
    try {
      bool returnValue = false;
      await Authentication().getUser().then((value1) async {
        var data = await db
            .collection('challenges')
            .doc(challengeID)
            .collection('daily_challenges')
            .doc(dayID)
            .get();
        if (data != null) {
          if (data['completed_users'].length > 0) {
            data['completed_users'].forEach((value) async {
              //this part looking for map keys contains or not
              //.keys value returning iterable value which like a list so I used contains
              if (value.keys.contains(value1.toString()) == true) {
                try {
                  await db
                      .collection('challenges')
                      .doc(challengeID)
                      .collection('daily_challenges')
                      .doc(dayID)
                      .update({
                    "completed_users": FieldValue.arrayRemove([value])
                  });
                  returnValue = true;
                } catch (e) {
                  print(e);
                  returnValue = false;
                }
              } else {
                print("yok");
                returnValue = false;
              }
            });
          } else {
            print("kucuk");
            returnValue = false;
          }
        } else {
          returnValue = false;
        }
      });
      return returnValue;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<bool> checkDayStatus(challengeID, dayID) async {
    try {
      bool returnValue = false;
      await Authentication().getUser().then((value1) async {
        var data = await db
            .collection('challenges')
            .doc(challengeID)
            .collection('daily_challenges')
            .doc(dayID)
            .get();
        if (data != null) {
          if (data['completed_users'].length > 0) {
            data['completed_users'].forEach((value) {
              //this part looking for map keys contains or not
              //.keys value returning iterable value which like a list so I used contains
              if (value.keys.contains(value1.toString()) == true) {
                print("buldum");
                returnValue = true;
              } else {
                print("yok");
                returnValue = false;
              }
            });
          } else {
            print("kucuk");
            returnValue = false;
          }
        } else {
          returnValue = false;
        }
      });
      return returnValue;
    } catch (e) {
      print(e);
      return false;
    }
  }
/////END UPDATE
  ///START GET METHODS

  static Future<List<DailyChallenge>> getDailyTasks(challangeID) async {
    List<DailyChallenge> dailChallenges = [];
    var data = await db
        .collection('challenges')
        .doc(challangeID)
        .collection("daily_challenges")
        .orderBy("day_number", descending: false)
        .get();
    if (data != null) {
      dailChallenges = data.docs
          .map((document) => DailyChallenge.fromMap(document))
          .toList();
    }
    int i = 0;
    dailChallenges.forEach((detail) {
      detail.id = data.docs[i].id;
      i++;
    });
    return dailChallenges;
  }

  ///END GET METHODS
  /// START POST METHODS
  static Future<bool> deleteChallenge(challengeID) async {
    try {
      await db.collection('challenges').doc(challengeID).delete();
      return true;
    } catch (e) {
      return false;
    }
  }

  static Future<bool> createNewChallenge(
      name, description, hardness, type, dayCount) async {
    try {
      await Authentication().getUser().then((value) {
        FirestoreHelper.getUserData(value).then((userData) async {
          await db.collection('challenges').add(ChallengeDetail(
                  "",
                  userData.fname,
                  userData.lname,
                  userData.email,
                  int.parse(hardness),
                  description,
                  name,
                  type,
                  int.parse(dayCount))
              .toMap());
        });
      });
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<DailyChallenge> addDailyChallenge(
      value, challengeID, day) async {
    await db
        .collection('challenges')
        .doc(challengeID)
        .collection("daily_challenges")
        .add(value);

    List<DailyChallenge> details = [];
    var data = await db
        .collection('challenges')
        .doc(challengeID)
        .collection("daily_challenges")
        .where("day_number", isEqualTo: day)
        .get();

    if (data != null) {
      details = data.docs
          .map((document) => DailyChallenge.fromMap(document))
          .toList();
    }
    int i = 0;
    details.forEach((detail) {
      detail.id = data.docs[i].id;
      i++;
    });

    return details[0];
  }

  /// END POST METHODS

}

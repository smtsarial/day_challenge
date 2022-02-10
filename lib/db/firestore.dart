import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:day_challenge/models/challenges.dart';

class FirestoreHelper {
  static final FirebaseFirestore db = FirebaseFirestore.instance;

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
}

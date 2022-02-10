import 'package:day_challenge/db/firestore.dart';
import 'package:day_challenge/models/challenges.dart';
import 'package:flutter/material.dart';

class ChallengeDetailList extends StatefulWidget {
  const ChallengeDetailList({Key? key, required this.challenge_id})
      : super(key: key);
  final String challenge_id;
  @override
  _ChallengeDetailListState createState() => _ChallengeDetailListState();
}

class _ChallengeDetailListState extends State<ChallengeDetailList> {
  List<ChallengeDetail> challengeListsDetail = [];
  late ChallengeDetail detailedDayChallenge = ChallengeDetail(
      "",
      "",
      "",
      "",
      0,
      0,
      [],
      "");
  @override
  void initState() {
    if (mounted) {
      FirestoreHelper.getDetailsList().then((data) {
        setState(() {
          challengeListsDetail = data;
        });
      });
      FirestoreHelper.getSpecificChallenge(widget.challenge_id).then((value) {
        setState(() {
          detailedDayChallenge = value;
        });
      });
    }
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(detailedDayChallenge.challenge_name),
      ),
      body: ListView.builder(
        itemCount: detailedDayChallenge.day_challenge.length,
        itemBuilder: (context, position) {
          return Card(
            margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
            child: Column(
              children: [
                ListTile(
                    title: Text(
                      "Day " + (position + 1).toString(),
                      style: TextStyle(
                          color: Colors.black, fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text("Subjects: " +
                        detailedDayChallenge.day_challenge[position].keys
                            .toString()),
                    trailing: Wrap(
                      spacing: 12,
                      children: [],
                    )),
              ],
            ),
          );
        },
      ),
    );
  }
}

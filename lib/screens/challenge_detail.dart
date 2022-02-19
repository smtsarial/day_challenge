import 'package:day_challenge/db/auth.dart';
import 'package:day_challenge/db/firestore.dart';
import 'package:day_challenge/models/dailyChallenges.dart';
import 'package:flutter/material.dart';

class ChallengeDetailList extends StatefulWidget {
  const ChallengeDetailList(
      {Key? key,
      required this.challenge_id,
      required this.challenge_name,
      required this.challenge_description})
      : super(key: key);
  final String challenge_id;
  final String challenge_name;
  final String challenge_description;
  @override
  _ChallengeDetailListState createState() => _ChallengeDetailListState();
}

class _ChallengeDetailListState extends State<ChallengeDetailList> {
  List<DailyChallenge> dailyChallenges = [];

  late bool isUserRegisteredToChallenge = false;
  late String userMail;

  @override
  void initState() {
    Authentication()
        .getUser()
        .then((value) => setState(() => userMail = value!));
    Authentication().getUser().then((value) =>
        FirestoreHelper.checkUserSubscribeOrNot(widget.challenge_id, value)
            .then((value) =>
                setState(() => {isUserRegisteredToChallenge = value})));

    if (mounted) {
      FirestoreHelper.getDailyTasks(widget.challenge_id).then((data) {
        setState(() {
          dailyChallenges = data;
        });
      });
    }
    super.initState();
  }

  Future<bool> registerChallenge() async {
    var data = await Authentication().getUser().then((value) =>
        FirestoreHelper.registerChallenge(widget.challenge_id, value));

    await FirestoreHelper.userRegistedChallenge(userMail, widget.challenge_id);
    return data;
  }

  Future<bool> unregisterChallenge() async {
    var data = await Authentication().getUser().then((value) =>
        FirestoreHelper.unregisterChallenge(widget.challenge_id, value));

    await FirestoreHelper.userUNRegistedChallenge(
        userMail, widget.challenge_id);
    return data;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(widget.challenge_name),
          actions: [
            isUserRegisteredToChallenge
                ? FlatButton(
                    onPressed: () {
                      unregisterChallenge().then(
                        (value) => value
                            ? setState(
                                (() => isUserRegisteredToChallenge = false))
                            : setState(
                                (() => isUserRegisteredToChallenge = true)),
                      );
                    },
                    child: Text(
                      'Remove',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))
                : FlatButton(
                    onPressed: () {
                      setState(() {
                        registerChallenge().then(
                          (value) => value
                              ? setState(
                                  (() => isUserRegisteredToChallenge = true))
                              : setState(
                                  (() => isUserRegisteredToChallenge = false)),
                        );
                      });
                    },
                    child: Text(
                      'Join',
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ))
          ],
        ),
        body: isUserRegisteredToChallenge
            ? (ListView.builder(
                itemCount: dailyChallenges.length,
                itemBuilder: (context, position) {
                  return Card(
                    margin: EdgeInsets.fromLTRB(2, 2, 2, 2),
                    child: Column(
                      children: [
                        ListTile(
                            title: Text(
                              "Day " + (position + 1).toString(),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.bold),
                            ),
                            subtitle: Text("Subjects: "),
                            trailing: Wrap(
                              spacing: 12,
                              children: [],
                            )),
                      ],
                    ),
                  );
                },
              ))
            : (SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      child: Center(
                          child: Column(
                        children: [
                          Text(
                            widget.challenge_name,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 40,
                                fontWeight: FontWeight.bold,
                                color: Colors.white),
                          ),
                          Center(
                            child: Text(
                              widget.challenge_id,
                              style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                          ),
                        ],
                      )),
                      padding: EdgeInsets.all(50),
                      color: Colors.grey,
                    ),
                    Container(
                      child: Center(
                        child: Text(
                          dailyChallenges.length.toString() + " Days",
                          style: TextStyle(
                              fontSize: 35,
                              fontWeight: FontWeight.bold,
                              color: Colors.black),
                        ),
                      ),
                      color: Color.fromARGB(26, 105, 105, 105),
                      padding: EdgeInsets.all(20),
                    ),
                    Container(
                      child: Center(
                        child: Column(
                          children: [
                            Text(
                              "Challenge Description",
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black),
                            ),
                            Text(widget.challenge_description.toString())
                          ],
                        ),
                      ),
                      padding: EdgeInsets.all(40),
                    )
                  ],
                ),
              )));
  }
}

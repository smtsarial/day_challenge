import 'package:day_challenge/main.dart';
import 'package:flutter/material.dart';

import 'package:day_challenge/db/firestore.dart';
import 'package:day_challenge/models/challenges.dart';
import 'package:day_challenge/screens/userSpecific/editMyChallenges/editDailyChallenge.dart';

class CreateNewChallenge extends StatefulWidget {
  const CreateNewChallenge({Key? key}) : super(key: key);

  @override
  _CreateNewChallengeState createState() => _CreateNewChallengeState();
}

class _CreateNewChallengeState extends State<CreateNewChallenge> {
  ChallengeDetail myChallenge =
      new ChallengeDetail("", "", "", "", 0, "", "", "", 0);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  TextEditingController challengeName = TextEditingController();
  TextEditingController challengeDescription = TextEditingController();
  TextEditingController star = TextEditingController();
  TextEditingController type = TextEditingController();

  TextEditingController day_count = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Center(
            child: Text("Create New Challenge"),
          ),
        ),
        body: SingleChildScrollView(
            child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 5) {
                      return 'Please fill the area!';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Challenge Name',
                  ),
                  controller: challengeName,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 5) {
                      return 'Please fill the area!';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Challenge Description',
                  ),
                  controller: challengeDescription,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please fill the area!';
                    } else if (int.parse(value) > 5) {
                      return "Please enter 1 between 5";
                    }
                    return null;
                  },
                  keyboardType: TextInputType.number,
                  maxLength: 1,
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Hardness',
                  ),
                  controller: star,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
                child: TextFormField(
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length < 3) {
                      return 'Please fill the area!';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Challenge Type',
                  ),
                  controller: type,
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 2, 16, 2),
                child: TextFormField(
                  keyboardType: TextInputType.number,
                  maxLength: 2,
                  validator: (value) {
                    if (value == null || value.isEmpty || value.length >= 3) {
                      return 'Please fill the area! Fill up to 99';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    border: UnderlineInputBorder(),
                    labelText: 'Day Count',
                  ),
                  controller: day_count,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      fixedSize: Size(350, 75),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25))),
                  onPressed: () {
                    FocusManager.instance.primaryFocus?.unfocus();
                    if (_formKey.currentState!.validate()) {
                      FirestoreHelper.createNewChallenge(
                              challengeName.text,
                              challengeDescription.text,
                              star.text,
                              type.text,
                              day_count.text)
                          .then((value) {
                        if (value == true) {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Challenge created successfully!"),
                          ));
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                            content: Text("Error occured!"),
                          ));
                        }
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  LaunchScreen(currentIndex: 2)),
                        );
                      });
                    }
                  },
                  child: const Text('Save Your Information'),
                ),
              ),
            ],
          ),
        )));
  }
}

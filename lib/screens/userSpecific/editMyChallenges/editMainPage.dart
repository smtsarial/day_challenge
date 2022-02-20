import 'package:day_challenge/db/firestore.dart';
import 'package:day_challenge/models/challenges.dart';
import 'package:flutter/material.dart';

class EditChallengeMain extends StatefulWidget {
  const EditChallengeMain({Key? key, required this.challengeID})
      : super(key: key);
  final String challengeID;

  @override
  _EditChallengeMainState createState() => _EditChallengeMainState();
}

class _EditChallengeMainState extends State<EditChallengeMain> {
  ChallengeDetail myChallenge =
      new ChallengeDetail("", "", "", "", 0, "", "", "", 0);
  @override
  void initState() {
    FirestoreHelper.getSpecificChallenge(widget.challengeID).then((value) => {
          if (mounted)
            {
              setState(
                () => {
                  myChallenge = value,
                  challengeName = TextEditingController(
                      text: myChallenge.challenge_name.toString()),
                  challengeDescription = TextEditingController(
                      text: myChallenge.challenge_description.toString()),
                  star =
                      TextEditingController(text: myChallenge.star.toString()),
                  type =
                      TextEditingController(text: myChallenge.type.toString()),
                  day_count = TextEditingController(
                      text: myChallenge.day_count.toString()),
                },
              )
            }
        });
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
          child: Text("Edit Your Challenge"),
        )),
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
                    if (value == null || value.isEmpty) {
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
                    if (value == null || value.isEmpty) {
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
                    if (value == null || value.isEmpty) {
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
                    if (value == null || value.isEmpty) {
                      return 'Please fill the area!';
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
                    // Validate returns true if the form is valid, or false otherwise.
                    if (_formKey.currentState!.validate()) {
                      // If the form is valid, display a snackbar. In the real world,
                      // you'd often call a server or save the information in a database.
                      FirestoreHelper.updateMainChallenge(
                              widget.challengeID,
                              ChallengeDetail(
                                      widget.challengeID,
                                      myChallenge.author_fname,
                                      myChallenge.author_lname,
                                      myChallenge.author_mail,
                                      int.parse(star.text),
                                      challengeDescription.text,
                                      challengeName.text,
                                      type.text,
                                      int.parse(day_count.text))
                                  .toMap())
                          .then((value) => {
                                value
                                    ? (ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Data added successfully')),
                                      ))
                                    : (ScaffoldMessenger.of(context)
                                        .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Error occured Please try again')),
                                      ))
                              });
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Processing Data')),
                      );
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

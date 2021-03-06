import 'package:day_challenge/db/ad_helper.dart';
import 'package:day_challenge/db/firestore.dart';
import 'package:day_challenge/db/storage.dart';
import 'package:day_challenge/models/challenges.dart';

import 'package:day_challenge/screens/challenge_detail.dart';
import 'package:day_challenge/screens/login/loginScreen.dart';
import 'package:day_challenge/screens/userSpecific/registeredChallenges.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChallengeList extends StatefulWidget {
  const ChallengeList({Key? key}) : super(key: key);

  @override
  _ChallengeListState createState() => _ChallengeListState();
}

class _ChallengeListState extends State<ChallengeList> {
  List<ChallengeDetail> challengeLists = [];
  List<ChallengeDetail> challengeListsCopy = [];
  late String userMail;

  TextEditingController editingController = TextEditingController();
  void refreshData() {
    initState();
  }

  onGoBack(dynamic value) {
    refreshData();
    setState(() {});
  }

  Future<void> readySharedPreferences() async {
    var sharedPreferences = await SharedPreferences.getInstance();
    var _usermail = sharedPreferences.getString("userMail");
    print(_usermail.toString());
    setState(() {
      userMail = _usermail.toString();
    });
  }

  @override
  void initState() {
    //Storage.listFiles();
    if (mounted) {
      _createBottomBannerAd();
      FirestoreHelper.getDetailsList().then((data) {
        if (mounted) {
          setState(() {
            challengeLists = data;
            challengeListsCopy = data;
          });
        }
      });
    }
    super.initState();
  }

  String filterSearchResults(String query) {
    List<ChallengeDetail> dummySearchList = [];
    dummySearchList.addAll(challengeLists);

    List<ChallengeDetail> dummyListData = [];
    if (query.isNotEmpty) {
      dummySearchList.forEach((item) {
        if (item.challenge_name.toLowerCase().contains(query.toLowerCase())) {
          dummyListData.add(item);
        }
      });
      setState(() {
        challengeLists = dummyListData;
      });
      return "dummyListData";
    } else if (query.isEmpty) {
      setState(() {
        challengeLists = challengeListsCopy;
      });
      return "";
    } else {
      setState(() {
        challengeLists = dummySearchList;
      });
      return "dummySearchList";
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 219, 219, 219),
      bottomNavigationBar: _isBottomBannerAdLoaded
          ? Container(
              height: _bottomBannerAd.size.height.toDouble(),
              width: _bottomBannerAd.size.width.toDouble(),
              child: AdWidget(ad: _bottomBannerAd),
            )
          : null,
      body: SafeArea(
        child: Container(
            child: Column(
          children: [
            Row(
              children: [
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(5, 0, 5, 5),
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(20),
                            bottomRight: Radius.circular(20)),
                        color: Colors.blueGrey,
                      ),
                      child: Column(
                        children: [
                          Container(
                              child: Padding(
                            padding: EdgeInsets.fromLTRB(0, 10, 0, 2),
                            child: Text(
                              "All Challenges",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 21,
                                  color: Colors.white),
                            ),
                          )),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 2, 20, 15),
                            child: TextField(
                              onChanged: (value) {
                                filterSearchResults(value);
                              },
                              controller: editingController,
                              decoration: InputDecoration(
                                  iconColor: Colors.white,
                                  focusedBorder: OutlineInputBorder(
                                    borderSide: BorderSide(color: Colors.white),
                                    borderRadius: BorderRadius.circular(25.7),
                                  ),
                                  fillColor: Colors.white,
                                  filled: true,
                                  hintText: "Search Challenge",
                                  prefixIcon: Icon(Icons.search),
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.circular(25.0)))),
                            ),
                          ),
                        ],
                      )),
                )),
              ],
            ),
            Expanded(
                child: challengeLists.isNotEmpty
                    ? ListView.builder(
                        itemCount: challengeLists.length,
                        itemBuilder: (context, position) {
                          ChallengeDetail item = challengeLists[position];
                          return Card(
                            margin: EdgeInsets.fromLTRB(12, 5, 12, 5),
                            child: Column(
                              children: [
                                ListTile(
                                    onTap: () => {
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    ChallengeDetailList(
                                                        challenge_id: item.id,
                                                        challenge_name:
                                                            item.challenge_name,
                                                        challenge_description: item
                                                            .challenge_description)),
                                          ).then(onGoBack)
                                        },
                                    title: Text(
                                      item.challenge_name.toString(),
                                      style: TextStyle(
                                          color: Colors.black,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    subtitle: Text((item.author_fname +
                                        " " +
                                        item.author_lname)),
                                    trailing: Wrap(
                                      spacing: 12,
                                      children: [
                                        Container(
                                          child: Column(
                                            children: [
                                              Text(
                                                "Type",
                                                style: TextStyle(
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                              Text(item.type.toString())
                                            ],
                                          ),
                                        ),
                                        Container(
                                          child: Column(
                                            children: [
                                              Text("Level"),
                                              RatingBarIndicator(
                                                rating: double.parse(
                                                    item.star.toString()),
                                                itemBuilder: (context, index) =>
                                                    Icon(
                                                  Icons.star,
                                                  color: Colors.amber,
                                                ),
                                                itemCount: 5,
                                                itemSize: 20.0,
                                                direction: Axis.horizontal,
                                              ),
                                            ],
                                          ),
                                        )
                                      ],
                                    )),
                              ],
                            ),
                          );
                        },
                      )
                    : Center(
                        child: Text("Challenges not found!"),
                      ))
          ],
        )),
      ),
    );
  }

// ADD SECTION
  @override
  void dispose() {
    super.dispose();
    _bottomBannerAd.dispose();
  }

  late BannerAd _bottomBannerAd;
  bool _isBottomBannerAdLoaded = false;
  void _createBottomBannerAd() {
    _bottomBannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            _isBottomBannerAdLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    _bottomBannerAd.load();
  }
}

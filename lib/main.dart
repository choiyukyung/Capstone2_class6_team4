import 'package:capstone/data/walking_info.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:capstone/services/mycolor.dart';
import 'package:capstone/pages/carbon_footprint.dart';
import 'package:capstone/pages/walk_map.dart';
import './pages/login.dart';
import './pages/signup.dart';
import './pages/screen_time.dart';
import 'data/user.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'SGreen Time',
      theme: ThemeData(
        //colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        fontFamily: 'Pretendard',
        useMaterial3: true,
      ),
      routes: {
        '/': (BuildContext context) => LogIn(),

        /*
        '/': (BuildContext context) => WalkRecord(
            user: User(id: "id", password: "password", name: "name", birthdate: "birthdate"),
            startTimeStamp: DateTime.now(),
            walkingInfo: WalkingInfo(name: "관악산둘레길", time: "2시간30분", distance: "6.2Km", details: ["난이도: 상"])
        ),
*/
        '/login': (BuildContext context) => const LogIn(),
        '/signup': (BuildContext context) => const SignUp(),
      }
    );
  }
}

class Main extends StatefulWidget {
  User? user;
  Main({required this.user, super.key});

  @override
  State<Main> createState() => _UsageStatsTestState();
}

class _UsageStatsTestState extends State<Main> {
  int currentIndex = 0;
  List body_item = [];

  @override
  void initState() {
    super.initState();

    body_item = [
      ScreenTime(user: widget.user),
      WalkMap(user: widget.user),
      CarbonFootprint(user: widget.user),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.deepGreenBlue,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(8), child: Text(""),
      ),
      bottomNavigationBar: BottomNavigationBar(
        //현재 index 변수에 저장
        currentIndex: currentIndex,
        //tap -> index 변경
        onTap: (index) {
          print('index test : ${index}');
          setState(() {
            currentIndex = index;
          });
        },
        backgroundColor: MyColors.brightGreenBlue,

        //BottomNavi item list
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.timer),
            label: 'screen time',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.mapLocationDot),
            label: 'walk map',
          ),
          BottomNavigationBarItem(
            icon: Icon(FontAwesomeIcons.seedling),
            label: 'carbon footprint',
          ),
        ],
        //selected된 item color
        selectedItemColor: MyColors.mint,
        //unselected된 item color
        unselectedItemColor: MyColors.deepGreenBlue,
        //unselected된 label text
        showSelectedLabels: true,
        //BottomNavigationBar Type -> fixed = bottom item size고정
        //BottomNavigationBar Type -> shifting = bottom item selected 된 item이 확대
        type: BottomNavigationBarType.fixed,
      ),

        //List item index로 Body 변경
        body: Center(
          child: body_item.elementAt(currentIndex),
        )
    );
  }
}
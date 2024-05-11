import 'package:capstone/services/mycolor.dart';
import 'package:capstone/pages/carbon_footprint.dart';
import 'package:capstone/pages/walk_map.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import './pages/login.dart';
import './pages/signup.dart';
import './pages/screen_time.dart';

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
        '/login': (BuildContext context) => LogIn(),
        '/signup': (BuildContext context) => SignUp(),
        '/main': (BuildContext context) => Main(),

        '/main/screen-time': (BuildContext context) => ScreenTime(""),
        //'/main/walk-map': (BuildContext context) => WalkMap(),
        //'/main/carbon-footprint': (BuildContext context) => CarbonFootPrint(),

        //'/main/screen-time/daily': (BuildContext context) => DailyScreenTime(""),
        //'/main/screen-time/weekly': (BuildContext context) => WeeklyScreenTime(""),
      }
    );
  }
}

class Main extends StatefulWidget {
  const Main({super.key});

  @override
  State<Main> createState() => _UsageStatsTestState();
}

class _UsageStatsTestState extends State<Main> {
  int currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.deepGreenBlue,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(0),
        child: AppBar(),
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
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'settings',
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

List body_item = [
  ScreenTime(''),
  WalkMap(),
  CarbonFootprint(),
  Text("settings"),
];
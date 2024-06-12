import 'dart:convert';

import 'package:capstone/data/walking_info.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:focus_detector/focus_detector.dart';
import 'package:http/http.dart' as http;
import 'package:vertical_barchart/vertical-barchartmodel.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../data/user.dart';
import '../main.dart';
import '../services/mycolor.dart';
import '../services/myapi.dart';

class WalkMap extends StatefulWidget {
  User? user;
  WalkMap({required this.user, super.key});

  @override
  State<WalkMap> createState() => _WalkMapState();
}

class _WalkMapState extends State<WalkMap> {
  static const mapHttps = Service.https; //"https://ca74-165-194-17-200.ngrok-free.app";

  Map? weather;
  DateTime? startTime;
  DateTime? finishTime;
  Service? service;

  @override
  void initState() {
    super.initState();

    service = Service(user: widget.user);
    initGeoData().then((res)=>{
      initWeatherData(res)
    });
  }

  Future<dynamic> initGeoData() async {
    Location location = new Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    _serviceEnabled = await location.serviceEnabled();
    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    _permissionGranted = await location.hasPermission();
    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    _locationData = await location.getLocation();
    return _locationData;
  }

  Future<Map> initWeatherData(var _locationData) async {
    var latitude = _locationData.latitude?.toStringAsFixed(2);
    var longitude = _locationData.longitude?.toStringAsFixed(2);

    try {
      String endpoint = "https://api.openweathermap.org/data/2.5/weather";
      String units = "metric";

      var response = await http.get(
        Uri.parse(
            "$endpoint?lat=$latitude&lon=$longitude&appid=${Service.openweatherKey}&units=$units"
        ),
      );
      print(response.body);
      if (response.statusCode == 200) {
        var json = jsonDecode(response.body);

        var currentWeather = {};
        currentWeather['name'] = json['name'];
        currentWeather['weather'] = json['weather'][0]['main'];
        //currentWeather['icon'] = json['weather']['icon'];
        currentWeather['temp'] = json['main']['temp'].toString();
        currentWeather['feelsLike'] = json['main']['feels_like'].toString();
        currentWeather['humidity'] = json['main']['humidity'].toString();

        setState(() {
          weather = currentWeather;
        });

      } else {
        print("Failed to get weather: ${response.statusCode}");
      }
    } catch (e) {
      print("Failed to get response: $e");
    }
    return {};
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            color: MyColors.deepGreenBlue,
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Flexible(
                      flex: 5,
                      child: Container(
                        width: 200,
                        height: 130,
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: MyColors.brightGreenBlue.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  'Location',
                                  style: TextStyle(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight
                                          .w500,
                                      color: Colors.white)
                              ),
                            ),
                            const SizedBox(height: 15,),
                            Text(
                                '${weather?['name']}',
                                style: const TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight
                                        .w500,
                                    color: Colors.white)
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Container(
                        width: 300,
                        height: 130,
                        padding: const EdgeInsets.all(10),
                        margin: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: MyColors.brightGreenBlue.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                              child: Text(
                                  'Weather',
                                  style: TextStyle(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight
                                          .w500,
                                      color: Colors.white)
                              ),
                            ),
                            const SizedBox(height: 16,),
                            Text(
                                '${weather?['weather']}',
                                style: const TextStyle(
                                    fontSize: 23.0,
                                    fontWeight: FontWeight
                                        .w500,
                                    color: Colors.white)
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10,),
                Container(
                  width: double.infinity,
                  height: 430,
                  padding: const EdgeInsets.all(15),
                  margin: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: MyColors.brightGreenBlue.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Column(
                    children: [
                      const Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                            'Map',
                            style: TextStyle(
                                fontSize: 13.0,
                                fontWeight: FontWeight
                                    .w500,
                                color: Colors.white)
                        ),
                      ),
                      const Spacer(),
                      SafeArea(
                          child: SizedBox(
                            height: 350,
                              child: MapWebView(https: mapHttps, user: widget.user),
                          )
                      ),


                      const SizedBox(height: 10,),
                    ],
                  ),
                ),
                const SizedBox(height: 15,),
                OutlineCircleButton(
                    radius: 50.0,
                    borderSize: 0.5,
                    onTap: () async {
                      var startTimeStamp = DateTime.now();
                      //var response = Service.queryNearCourse();

                      if (true){ //response == "nearCourse"
                        WalkingInfo? data = await service?.getWalkingInfo(widget.user);
                        if (data?.name != "null") {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => WalkRecord(
                                        user: widget.user,
                                        startTimeStamp: startTimeStamp,
                                        walkingInfo: data,
                                      )));
                        } else {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return Dialog(
                                child: Container(
                                  width: 200, height: 150,
                                  padding: const EdgeInsets.all(15),
                                  decoration: BoxDecoration(
                                    color: MyColors.deepBlue,
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      const SizedBox(height: 10,),
                                      const Text(
                                        "Please select a near course.",
                                        style: const TextStyle(color: Colors.white, fontSize: 14),
                                      ),
                                      const SizedBox(height: 30,),
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: ElevatedButton(
                                          style: ElevatedButton.styleFrom(
                                              shape: RoundedRectangleBorder(	//모서리를 둥글게
                                                  borderRadius: BorderRadius.circular(20)),
                                              backgroundColor: Colors.white,

                                              //child 정렬 - 아래의 Text('$test')
                                              alignment: Alignment.center,
                                              textStyle: const TextStyle(fontSize: 15, color: MyColors.deepBlue)
                                          ),

                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: const Text('close'),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              );
                            },
                          );
                        }
                      } else {
                        print("queryNearCourse response: None");
                        //수정: popup
                      }
                    },
                    child: const Icon(Icons.play_arrow_rounded, size: 28,)
                ),
              ],
            )
        )
    );
  }
}

class MapWebView extends StatefulWidget {
  final String https;
  User? user;
  MapWebView({super.key, required this.https, required this.user});

  @override
  State<MapWebView> createState() => _MapWebViewState();
}

class _MapWebViewState extends State<MapWebView> {
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();


    _webViewController = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..loadRequest(Uri.parse("${widget.https}/vworldData/${widget.user?.id}"));
    //  **WebChromeClient 설정**: WebViewController에 WebChromeClient를 설정합니다.
    // WebChromeClient 설정
    //_webViewController?.setWebChromeClient(WebChromeClient());

    /*
      ..addJavaScriptChannel(
        'ChannelName',
          onMessageReceived: (JavaScriptMessage message) {
          debugPrint(message.message);
      },



    WebSettings webSettings= WebView.getSettings();
    webSettings.setJavaScriptEnabled(true);
    webSettings.setUseWideViewPort(true);
    webSettings.setLoadWithOverviewMode(true);
    webSettings.setBuiltInZoomControls(true);
    webSettings.setSupportZoom(true); //줌 아이콘
  */
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox( //scaffold?
      child: WebViewWidget(controller: _webViewController!),
    );
  }
}



class WalkRecord extends StatefulWidget {
  User? user;
  DateTime startTimeStamp;
  WalkingInfo? walkingInfo;
  //String? location;


  WalkRecord({required this.user, required this.startTimeStamp, required this.walkingInfo, super.key});

  @override
  State<WalkRecord> createState() => _WalkRecordState();
}

class _WalkRecordState extends State<WalkRecord> {
  Service? service;
  var walkingRanking;
  int distractionCount = 0;

  Color blockColor = Colors.blueAccent;

  @override
  void initState() {
    super.initState();

    service = Service(user: widget.user);
  }

  void initWalkingRanking() async {
    // 방법 1: 초기화를 통해 빈 리스트 할당
    walkingRanking = [];

    var response = await service?.getWalkingRanking();
    if (response!=null){
      walkingRanking = response;
    }
  }

  @override
  Widget build(BuildContext context) {
    Duration totalWalkTime;

    return PopScope(
      canPop: false, //뒤로가기 버튼 제한

      child: FocusDetector(
        key: Key("${widget.key}"),

        onForegroundLost: () {
          setState(() {
            distractionCount += 1;
          });
          /*
          'Foreground Lost.'
              'It means, for example, that the user sent your app to the '
              'background by opening another app or turned off the device\'s '
              'screen while your widget was visible.',
        */
        },

        child: Scaffold(
          backgroundColor: MyColors.deepBlue,

          body: Container(
            padding: const EdgeInsets.all(5),

            child: Column(
              children: [
                Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(7),
                        width: double.infinity, height: 130,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.asset(
                            "assets/images/blue_map.jpg",
                            fit: BoxFit.fill,
                            opacity: const AlwaysStoppedAnimation(.6),
                          ),
                        ),
                      ),
                      Container(
                        margin: const EdgeInsets.all(7),
                        padding: const EdgeInsets.all(15),
                        child: Column(
                          children: [
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Region',
                                  style: TextStyle(
                                    fontSize: 12,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          blurRadius: 10.0,  // shadow blur
                                          color: Colors.lightBlueAccent, // shadow color
                                          offset: Offset(2.0,2.0), // how much shadow will be shown
                                        ),
                                      ],
                                  ),
                                )
                            ),
                            const SizedBox(height: 20,),
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Text(
                                "${widget.walkingInfo?.name}",
                                style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 21,
                                  shadows: [
                                    Shadow(
                                      blurRadius: 13.0,  // shadow blur
                                      color: Colors.lightBlueAccent, // shadow color
                                      //offset: Offset(2.0,2.0), // how much shadow will be shown
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ]
                ),
                Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: Container(
                        height: 120,
                        margin: const EdgeInsets.all(7),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: blockColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),

                        child: Column(
                          children: [
                            const Align(
                              alignment: Alignment.topLeft,
                                child: Text(
                                    'Time',
                                  style: TextStyle(fontSize: 12, color: Colors.white),
                                )
                            ),
                            const SizedBox(height: 10,),
                            Text(
                                "${widget.walkingInfo?.time}",
                              style: const TextStyle(color: Colors.white, fontSize: 23),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Flexible(
                      flex: 2,
                      child: Container(
                        height: 120,
                        margin: const EdgeInsets.all(7),
                        padding: const EdgeInsets.all(15),
                        decoration: BoxDecoration(
                          color: blockColor.withOpacity(0.3),
                          borderRadius: BorderRadius.circular(10),
                        ),

                        child: Column(
                          children: [
                            const Align(
                                alignment: Alignment.topLeft,
                                child: Text(
                                  'Distance',
                                  style: TextStyle(fontSize: 12, color: Colors.white),
                                )
                            ),
                            const SizedBox(height: 10,),
                            Text(
                              "${widget.walkingInfo?.distance} ",
                              style: const TextStyle(color: Colors.white, fontSize: 24),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                Container(
                  width: double.infinity, height: 290,
                  margin: const EdgeInsets.all(7),
                  padding: const EdgeInsets.all(15),
                  decoration: BoxDecoration(
                    color: blockColor.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(10),
                  ),

                  child: Column(
                    children: [
                      const Align(
                          alignment: Alignment.topLeft,
                          child: Text(
                            'Ranking',
                            style: TextStyle(fontSize: 12, color: Colors.white),
                          )
                      ),
                      const SizedBox(height: 15,),
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(left: 10, right: 10),
                          child: ListView.builder(
                            // 방법 2: null 안전성을 고려한 length 접근
                            itemCount: walkingRanking?.length ?? 0,
                            itemBuilder: (BuildContext context, int index) {
                              return Card(
                                  elevation: 1,
                                  shape: const RoundedRectangleBorder(
                                      borderRadius: BorderRadius.all(
                                          Radius.elliptical(20, 20))),

                                  child: GestureDetector(
                                    //onTap: () => cardClickEvent(context, walingRanking[index]),
                                    child: Container(
                                      height: 70,
                                      width: double.infinity,
                                      padding: const EdgeInsets.all(15),
                                      //margin: const EdgeInsets.all(32),
                                      decoration: BoxDecoration(
                                          gradient: const LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors:
                                            [
                                              Color(0xFF6e45e2),
                                              Color(0xFF755EE8),
                                              Color(0xFFa86aa4),
                                              Color(0xFFcc6b8e),
                                              Color(0xFFf18271),
                                              Color(0xFFf3a469),
                                              Color(0xFFf7c978),
                                              //Color(0xFF74ebd5),
                                              //Color(0xFF9face6),
                                              //Color(0xFF846AFF),
                                              //Color(0xFF755EE8),
                                              //Colors.purpleAccent,
                                              //Colors.amber,
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(10)),
                                      // Adds a gradient background and rounded corners to the container
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment
                                            .center,
                                        crossAxisAlignment: CrossAxisAlignment
                                            .start,
                                        children: [
                                          Column(
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Row(
                                                children: [
                                                  const SizedBox(width: 5,),
                                                  Text(
                                                    '${index + 1}',
                                                    style: const TextStyle(
                                                      fontSize: 20.0,
                                                      fontWeight: FontWeight
                                                          .w700,
                                                      color: Colors.white,
                                                      shadows: [
                                                        Shadow(
                                                          blurRadius: 5.0,  // shadow blur
                                                          color: Colors.white, // shadow color
                                                          offset: Offset(0,0), // how much shadow will be shown
                                                        ),
                                                      ],
                                                    ),
                                                  ),
                                                  const SizedBox(width: 15,),
                                                  Text(
                                                      '${walkingRanking[index]["id"]}',
                                                      style: const TextStyle(
                                                          fontSize: 16.0,
                                                          fontWeight: FontWeight
                                                              .w500,
                                                          color: Colors.white)
                                                  ),
                                                  const Spacer(),
                                                  Text(
                                                      '${walkingRanking[index]["walkingTime"]}',
                                                      style: const TextStyle(
                                                        fontSize: 21.0,
                                                        fontWeight: FontWeight
                                                            .w500,
                                                        color: Colors.white,
                                                      )
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                              );
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30,),
                OutlineCircleButton(
                    radius: 50.0,
                    borderSize: 0.5,
                    onTap: () async {
                      var finishTimeStamp = DateTime.now();

                      showDialog(
                        context: context,
                        builder: (context) {
                          return Dialog(
                            child: Container(
                              width: 200, height: 150,
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                color: MyColors.deepBlue,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 10,),
                                  const Text(
                                      "Do you want to finish?",
                                    style: const TextStyle(color: Colors.white, fontSize: 16),
                                  ),
                                  const SizedBox(height: 30,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(	//모서리를 둥글게
                                                borderRadius: BorderRadius.circular(20)),
                                            backgroundColor: Colors.white,

                                            //child 정렬 - 아래의 Text('$test')
                                            alignment: Alignment.center,
                                            textStyle: const TextStyle(fontSize: 15, color: MyColors.deepBlue)
                                        ),

                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('no'),
                                      ),
                                      const SizedBox(width: 5,),
                                      ElevatedButton( //int is not a subtype of type double?
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(	//모서리를 둥글게
                                                borderRadius: BorderRadius.circular(20)),
                                            backgroundColor: Colors.white,

                                            //child 정렬 - 아래의 Text('$test')
                                            alignment: Alignment.center,
                                            textStyle: const TextStyle(fontSize: 15, color: MyColors.deepBlue)
                                        ),

                                        onPressed: () async {
                                          totalWalkTime = finishTimeStamp.difference(widget.startTimeStamp);
                                          var result = await service?.postWalkingReport(
                                            totalWalkTime,
                                            distractionCount
                                          );
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => WalkReport(
                                                user: widget.user,
                                                name: widget.walkingInfo?.name,
                                                time: "${totalWalkTime.inMinutes}", //seconds 변환?
                                                mileage: result["walking"]["car"] ?? 0,
                                                tree: result["walking"]["tree"] ?? 0,
                                                distraction: distractionCount,
                                                pastRanking: walkingRanking,
                                              ),
                                            ),
                                          );
                                        },
                                        child: const Text('yes'),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: const Icon(Icons.stop)
                ),
                const SizedBox(width: 50,),
                const SizedBox(height: 10,),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


class WalkReport extends StatefulWidget {
  User? user;
  String? name;
  String? time;
  double mileage;
  double tree;
  int distraction;
  List<dynamic> pastRanking;

  WalkReport({
    required this.user,
    required this.name,
    required this.time,
    required this.mileage,
    required this.tree,
    required this.distraction,
    required this.pastRanking,
    super.key,
  });

  @override
  State<WalkReport> createState() => _WalkReportState();
}

class _WalkReportState extends State<WalkReport> {
  Service? service;
  var walkingRanking;
  num rankingDiff = 0; //음수: ranking up, 양수: ranking down

  final controller = PageController(viewportFraction: 0.8, keepPage: true);

  static final pageColors = [
    MyColors.skyBlue,
    Colors.deepOrange,
    MyColors.deepGreen,
    //Colors.indigoAccent,
    Colors.tealAccent.shade700,
    Colors.black26
  ];
/*
  List<VBarChartModel> appdata = [
    const VBarChartModel(
      index: 0,
      label: "today",
      colors: [Colors.orange, Colors.deepOrange],
      jumlah: 130,
      tooltip: "130m",
    ),
    VBarChartModel(
      index: 1,
      label: "yesterday",
      colors: [Colors.lime, Colors.green.shade600],
      jumlah: 78,
      tooltip: "78m",
    ),
  ];
*/
  @override
  void initState() {
    super.initState();

    service = Service(user: widget.user);
    initWalkingRanking();
  }

  void initWalkingRanking() async {
    // 방법 1: 초기화를 통해 빈 리스트 할당
    //walkingRanking = [];
    walkingRanking = [
      {
        'id': 'master',
        'walkingTime': 110.0,
      },
      {
        'id': 'user1',
        'walkingTime': 100.0,
      },
      {
        'id': 'user2',
        'walkingTime': 90.0,
      },
      {
        'id': 'user4',
        'walkingTime': 70.0,
      },
      {
        'id': 'user5',
        'walkingTime': 60.0,
      },
      {
        'id': 'user6',
        'walkingTime': 50.0,
      },
      {
        'id': 'user7',
        'walkingTime': 40.0,
      },
      {
        'id': 'user8',
        'walkingTime': 30.0,
      },
      {
        'id': 'user9',
        'walkingTime': 20.0,
      },
      {
        'id': 'user10',
        'walkingTime': 10.0,
      },
    ];


    var response = await service?.getWalkingRanking();
    if (response!=null && response.isNotEmpty){
      walkingRanking = response;
    }

    for (var user in walkingRanking) {
      if (user['id'] == widget.user?.id) {
        rankingDiff += walkingRanking.indexOf(user);
        print(walkingRanking.indexOf(user));
      }
    }

    var pastRanking = widget.pastRanking;
    for (var user in pastRanking) {
      if (user['id'] == widget.user?.id) {
        rankingDiff -= pastRanking.indexOf(user);
        print(pastRanking.indexOf(user));
      }
    }

    print('rankingDiff: $rankingDiff');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        color: MyColors.deepGreenBlue,
        padding: const EdgeInsets.all(5),
        child: Column(
          children: [
            Align(
              alignment: Alignment.topLeft,
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: ElevatedButton(
                    onPressed: (){
                      //Navigator.pop(context);
                      Navigator.push(context, MaterialPageRoute(builder: (context)=>Main(user: widget.user)));
                    },
                    style:  ElevatedButton.styleFrom(
                      backgroundColor: MyColors.brightGreenBlue.withOpacity(0.5),
                        shape: RoundedRectangleBorder(	//모서리를 둥글게
                            borderRadius: BorderRadius.circular(5)),
                        // onPrimary: Colors.blue,	//글자색
                        minimumSize: const Size(40, 30),	//width, height

                        //child 정렬 - 아래의 Text('$test')
                        alignment: Alignment.centerLeft,
                        textStyle: const TextStyle(fontSize: 30)
                    ),

                    child: const Text(
                      "skip",
                      style: TextStyle(fontSize: 13.0,
                          fontWeight: FontWeight.w500,
                          color: Colors.white),
                    ),
                ),
              ),
            ),
            const SizedBox(height: 10,),
            const Text(
              "Daily Report Cards",
              style: TextStyle(fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            Spacer(),
            Flexible(
              flex: 10,
              child: SizedBox(
                width: 500,
                height: 450,
                child: PageView.builder(
                  controller: controller,
                  // itemCount: pages.length,
                  itemBuilder: (_, index) {
                    var pageContents = [
                      ['your total time...', '${widget.time}', 'min'],
                      ['you reduced carbon \nas much as...', (widget.mileage.toStringAsFixed(2)), 'm',],
                      ['you reduced carbon \nas much as...', (widget.tree.toStringAsFixed(2)), 'CO2/hour',],
                      //['you unlocked...', '${widget.name}', '',],
                      ['your total distractions...', '${widget.distraction}', '',],
                      [],
                    ];

                    final pages = List.generate(
                        pageContents.length,
                            (index) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(16),
                            color: pageColors[index],
                          ),
                          margin: const EdgeInsets.fromLTRB(15, 30, 15, 5),
                          child: (index==4) ?
                          //Ranking Card
                            Container(
                              width: double.infinity, height: 800,
                              margin: const EdgeInsets.all(7),
                              padding: const EdgeInsets.all(15),
                              decoration: BoxDecoration(
                                //color: MyColors.brightGreenBlue.withOpacity(0.3),
                                borderRadius: BorderRadius.circular(10),
                              ),

                              child: Column(
                                children: [
                                  SizedBox(
                                    width: 410,
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        const Text(
                                            'Carbon Footprint Ranking',
                                            textAlign: TextAlign.start,
                                            style: TextStyle(fontSize: 15.0,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white)
                                        ),
                                        Text(
                                            (rankingDiff < 0) ?
                                            '${(rankingDiff)*-1} up'
                                            : '$rankingDiff down',
                                            textAlign: TextAlign.start,
                                            style: const TextStyle(fontSize: 15.0,
                                                fontWeight: FontWeight.w500,
                                                color: Colors.white)
                                        ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 10,),
                                  Expanded(
                                    child: Container(
                                      width: double.infinity, height: 800,
                                      margin: const EdgeInsets.all(7),
                                      //padding: const EdgeInsets.all(15),
                                      decoration: BoxDecoration(
                                        //color: MyColors.brightGreenBlue.withOpacity(0.3),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      child: ListView.builder(
                                        // 방법 2: null 안전성을 고려한 length 접근
                                        itemCount: walkingRanking?.length ?? 0,
                                        itemBuilder: (BuildContext context, int index) {
                                          return Card(
                                              elevation: 1,
                                              shape: const RoundedRectangleBorder(
                                                  borderRadius: BorderRadius.all(
                                                      Radius.elliptical(20, 20))),

                                              child: GestureDetector(
                                                //onTap: () => cardClickEvent(context, walingRanking[index]),
                                                child: Container(
                                                  height: 70,
                                                  width: double.infinity,
                                                  padding: const EdgeInsets.all(15),
                                                  //margin: const EdgeInsets.all(32),
                                                  decoration: BoxDecoration(
                                                      gradient: const LinearGradient(
                                                        begin: Alignment.topLeft,
                                                        end: Alignment.bottomRight,
                                                        colors:
                                                        [
                                                          Color(0xFF6e45e2),
                                                          Color(0xFF755EE8),
                                                          Color(0xFFa86aa4),
                                                          Color(0xFFcc6b8e),
                                                          Color(0xFFf18271),
                                                          Color(0xFFf3a469),
                                                          Color(0xFFf7c978),
                                                          //Color(0xFF74ebd5),
                                                          //Color(0xFF9face6),
                                                          //Color(0xFF846AFF),
                                                          //Color(0xFF755EE8),
                                                          //Colors.purpleAccent,
                                                          //Colors.amber,
                                                        ],
                                                      ),
                                                      borderRadius: BorderRadius.circular(10)),
                                                  // Adds a gradient background and rounded corners to the container
                                                  child: Column(
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .center,
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .start,
                                                    children: [
                                                      Column(
                                                        crossAxisAlignment: CrossAxisAlignment
                                                            .start,
                                                        children: [
                                                          Row(
                                                            children: [
                                                              const SizedBox(width: 5,),
                                                              Text(
                                                                '${index + 1}',
                                                                style: const TextStyle(
                                                                  fontSize: 20.0,
                                                                  fontWeight: FontWeight
                                                                      .w700,
                                                                  color: Colors.white,
                                                                  shadows: [
                                                                    Shadow(
                                                                      blurRadius: 5.0,  // shadow blur
                                                                      color: Colors.white, // shadow color
                                                                      offset: Offset(0,0), // how much shadow will be shown
                                                                    ),
                                                                  ],
                                                                ),
                                                              ),
                                                              const SizedBox(width: 15,),
                                                              Text(
                                                                  '${walkingRanking[index]["id"]}',
                                                                  style: const TextStyle(
                                                                      fontSize: 16.0,
                                                                      fontWeight: FontWeight
                                                                          .w500,
                                                                      color: Colors.white)
                                                              ),
                                                              const Spacer(),
                                                              Text(
                                                                  '${walkingRanking[index]["walkingTime"]}',
                                                                  style: const TextStyle(
                                                                    fontSize: 21.0,
                                                                    fontWeight: FontWeight
                                                                        .w500,
                                                                    color: Colors.white,
                                                                  )
                                                              ),
                                                            ],
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              )
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            )
                              : Stack(
                            children: [
                              ShaderMask(
                                shaderCallback: (Rect bound) {
                                  return const LinearGradient(
                                      begin: Alignment.bottomCenter,
                                      end: Alignment.topCenter,
                                      // 그라데이션 분포 비율로 컬러를 설정했음
                                      stops: [0, 0.5],
                                      colors: [
                                        Colors.transparent,
                                        Colors.white,
                                      ]).createShader(bound);
                                },
                                blendMode: BlendMode.dstIn,
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(10),
                                  child: Image.asset(
                                      "assets/images/report_card_$index.jpg",
                                      fit: BoxFit.fitHeight
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const SizedBox(height: 180,),
                                  Text(
                                    pageContents[index][0],
                                    textAlign: TextAlign.start,
                                    style: const TextStyle(fontSize: 15.0,
                                        fontWeight: FontWeight.w500,
                                        color: Colors.white),
                                  ),
                                  const SizedBox(height: 10,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        pageContents[index][1],
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(fontSize: 30.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                      Text(
                                        "\n ${pageContents[index][2]}",
                                        textAlign: TextAlign.start,
                                        style: const TextStyle(fontSize: 12.0,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 40,),
                                ],
                              ),
                            ],
                          ),
                        )
                    );

                    return pages[index % pages.length];
                  },
                ),
              ),
            ),
            const Spacer(),
            Flexible(
              flex: 1,
              child: SmoothPageIndicator(
                controller: controller,
                count: 5,
                effect: const ScrollingDotsEffect(
                  activeDotColor: MyColors.mint,
                  activeStrokeWidth: 2.6,
                  activeDotScale: 1.3,
                  maxVisibleDots: 5,
                  radius: 8,
                  spacing: 10,
                  dotHeight: 12,
                  dotWidth: 12,
                       ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class OutlineCircleButton extends StatelessWidget {
  OutlineCircleButton({
    this.onTap,
    this.borderSize = 0.5,
    this.radius = 20.0,
    this.borderColor = Colors.black,
    this.foregroundColor = Colors.white,
    this.child,
  });

  final onTap;
  final radius;
  final borderSize;
  final borderColor;
  final foregroundColor;
  final child;

  @override
  Widget build(BuildContext context) {
    return ClipOval(
      child: Container(
        width: radius,
        height: radius,
        decoration: BoxDecoration(
          border: Border.all(color: borderColor, width: borderSize),
          color: foregroundColor,
          shape: BoxShape.circle,
        ),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
              child: child??const SizedBox(),
              onTap: () async {
                if(onTap != null) {
                  onTap();
                }
              }
          ),
        ),
      ),
    );
  }
}

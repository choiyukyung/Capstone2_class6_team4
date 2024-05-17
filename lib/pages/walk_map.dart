import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:vertical_barchart/vertical-barchartmodel.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../services/mycolor.dart';
import '../services/myapi.dart';

class WalkMap extends StatefulWidget {
  const WalkMap({super.key});

  @override
  State<WalkMap> createState() => _WalkMapState();
}

class _WalkMapState extends State<WalkMap> {
  String? latitude;
  String? longitude;
  String? address;
  DateTime? startTime;
  DateTime? finishTime;

  Service myService = Service();

  Future<void> getGeoData() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('permissions are denied');
      }
    }

    var currentPosition = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.low);
    //var lastPosition = await Geolocator.getLastKnownPosition();

    var currentAddress = myService.queryAddress(currentPosition);

    setState(() {
      latitude = currentPosition.latitude.toString();
      longitude = currentPosition.longitude.toString();
      address = currentAddress;
    });
  }

  @override
  void initState() {
    super.initState();

    getGeoData();
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
                      flex: 2,
                      child: Container(
                        width: 200,
                        height: 130,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.lime,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text('your location...\n$address'),
                      ),
                    ),
                    Flexible(
                      flex: 3,
                      child: Container(
                        width: 300,
                        height: 130,
                        padding: EdgeInsets.all(5),
                        margin: EdgeInsets.all(5),
                        decoration: BoxDecoration(
                          color: Colors.lime,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text('Today\'s weather...\nsunny'),
                      ),
                    ),
                  ],
                ),

                Text('longtitude: ${longitude}'),
                Text('latitude: ${latitude}'),
                ElevatedButton(
                    onPressed: (){
/*
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const MapWebView(),)
                      );
*/
                    },
                    child: const Text('Start'),
                ),
                ElevatedButton(
                  onPressed: (){

                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const WalkReport(),)
                    );

                  },
                  child: const Text('Stop'),
                ),
              ],
            )
        )
    );
  }
}

class MapWebView extends StatefulWidget {
  const MapWebView({super.key});

  @override
  State<MapWebView> createState() => _MapWebViewState();
}

class _MapWebViewState extends State<MapWebView> {
  WebViewController? _webViewController;

  @override
  void initState() {
    super.initState();

    _webViewController = WebViewController()
      ..loadRequest(Uri.parse('https://2acb-218-146-29-181.ngrok-free.app/vworldData'))
      ..setJavaScriptMode(JavaScriptMode.unrestricted);
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
    return Scaffold(
      body: WebViewWidget(controller: _webViewController!),
    );
  }
}



/*
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

class WalkMap extends StatefulWidget {
  const WalkMap({super.key});

  @override
  State<WalkMap> createState() => _WalkMapState();
}

class _WalkMapState extends State<WalkMap> {
  final GlobalKey webViewKey = GlobalKey();
  WebUri webUrl = WebUri.uri(UriData.fromString("https://naver.com").uri);
  InAppWebViewController? webViewController;
  PullToRefreshController? pullToRefreshController;
  double progress = 0;

  String? latitude;
  String? longitude;

  Future<void> initWebView() async {
    pullToRefreshController = (kIsWeb
        ? null
        : PullToRefreshController(
      onRefresh: () async {
        if (defaultTargetPlatform == TargetPlatform.android) {
          webViewController!.reload();
        } else if (defaultTargetPlatform == TargetPlatform.iOS || defaultTargetPlatform == TargetPlatform.macOS) {
          webViewController!.loadUrl(urlRequest: URLRequest(url: await webViewController!.getUrl()));}
      },
    ))!;
  }

  Future<void> getGeoData() async {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('permissions are denied');
      }
    }

    Position position = await Geolocator.getCurrentPosition();
    setState(() {
      latitude = position.latitude.toString();
      longitude = position.longitude.toString();
    });
  }

  Future<bool> _goBack(BuildContext context) async{
    if(await webViewController!.canGoBack()){
      webViewController!.goBack();
      return Future.value(false);
    }else{
      return Future.value(true);
    }
  }

  @override
  void initState() {
    super.initState();

    getGeoData();
    initWebView();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Text('longtitude: ${longitude}'),
            Text('latitude: ${latitude}'),
            SafeArea(
                child: WillPopScope(
                    onWillPop: () => _goBack(context),
                    child: Column(children: <Widget>[
                      progress < 1.0
                          ? LinearProgressIndicator(value: progress, color: Colors.blue)
                          : Container(),
                      Expanded(
                          child: Stack(children: [
                            InAppWebView(
                              key: webViewKey,
                              initialUrlRequest: URLRequest(url: webUrl),
                              pullToRefreshController: pullToRefreshController,
                              onLoadStart: (InAppWebViewController controller, uri) {
                                setState(() {webUrl = uri!;});
                              },
                              onLoadStop: (InAppWebViewController controller, uri) {
                                setState(() {webUrl = uri!;});
                              },
                              onProgressChanged: (controller, progress) {
                                if (progress == 100) {pullToRefreshController!.endRefreshing();}
                                setState(() {this.progress = progress / 100;});
                              },
                              onWebViewCreated: (InAppWebViewController controller) {
                                webViewController = controller;
                              },
                              onCreateWindow: (controller, createWindowRequest) async{
                                showDialog(
                                  context: context, builder: (context) {
                                  return AlertDialog(
                                    content: SizedBox(
                                      width: MediaQuery.of(context).size.width,
                                      height: 400,
                                      child: InAppWebView(
                                        // Setting the windowId property is important here!
                                        windowId: createWindowRequest.windowId,
                                        onCloseWindow: (controller) async{
                                          if (Navigator.canPop(context)) {
                                            Navigator.pop(context);
                                          }
                                        },
                                      ),
                                    ),);
                                },
                                );
                                return true;
                              },
                            )
                          ]))
                    ])
                ),
            ),
          ],
        ),
      ),
    );
  }
}
*/

class WalkReport extends StatefulWidget {
  const WalkReport({super.key});

  @override
  State<WalkReport> createState() => _WalkReportState();
}

class _WalkReportState extends State<WalkReport> {
  final controller = PageController(viewportFraction: 0.8, keepPage: true);

  static final pageContents = [
    ['your total time...', '100', 'min'],
    ['your total distance...', '1.2', 'km',],
    ['you save...', '100', 'km',],
    ['you save...', '20', 'trees',],
    ['you unlocked...', 'Han-river', '',],
  ];
  static final pageColors = [
    MyColors.skyBlue,
    Colors.tealAccent.shade700,
    Colors.deepOrange,
    MyColors.deepGreen,
    Colors.indigoAccent,
  ];

  final pages = List.generate(
      5,
          (index) => Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16),
              color: pageColors[index],
              ),
            margin: const EdgeInsets.fromLTRB(15, 30, 15, 5),
            child: SizedBox(
              height: 280,
              child: Stack(
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
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        pageContents[index][0],
                        textAlign: TextAlign.start,
                        style: const TextStyle(fontSize: 17.0,
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
                            style: TextStyle(fontSize: 50.0,
                                fontWeight: FontWeight.w500,
                                color: Colors.white),
                          ),
                          Text(
                            "\n ${pageContents[index][2]}",
                            textAlign: TextAlign.start,
                            style: TextStyle(fontSize: 15.0,
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
            ),
          )
  );


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
                      Navigator.pop(context);
                    },
                    style:  ElevatedButton.styleFrom(
                      backgroundColor: MyColors.brightGreenBlue.withOpacity(0.5),
                        shape: RoundedRectangleBorder(	//모서리를 둥글게
                            borderRadius: BorderRadius.circular(5)),
                        // onPrimary: Colors.blue,	//글자색
                        minimumSize: Size(40, 30),	//width, height

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
            const Text(
              "Daily Report Cards",
              style: TextStyle(fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            //DotLineChart(appdata),
            Flexible(
              flex: 10,
              child: SizedBox(
                height: 600,
                child: PageView.builder(
                  controller: controller,
                  // itemCount: pages.length,
                  itemBuilder: (_, index) {
                    return pages[index % pages.length];
                  },
                ),
              ),
            ),
            Spacer(),
            Flexible(
              flex: 1,
              child: SmoothPageIndicator(
                controller: controller,
                count: pages.length,
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

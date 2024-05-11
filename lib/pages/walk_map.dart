import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
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

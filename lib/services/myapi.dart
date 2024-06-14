import 'dart:async';
import 'dart:convert';
import 'package:capstone/data/walking_info.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:location/location.dart';
import 'package:usage_stats/usage_stats.dart';

import '../data/usage_stats.dart';
import '../data/user.dart';

class Service {
  User? user;
  Service({required this.user});

  static const https = "https://port-0-sgreentime-server-deploy-1lxbhvsa5.sel5.cloudtype.app";
  static const naverId = "apsz5g7nue";
  static const naverKey = "E4QCjVeH5c4MTYKUVIHM1QLK7Z96qyLzU2fB50my";
  static const openweatherKey = "a1348d850873d2c02fb6e5c160881ecf";
  static const MethodChannel _channel = MethodChannel('usage_stats');

  static Future<bool?> queryUserInfo(User user) async {
    try {
      final response = await http.post(
        Uri.parse("$https/member/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data["message"] == "success") {
          return true;
        } else {
          return false;
        }
      }
    } catch (e) {
      print("queryUserInfo: Failed to get response: $e");
    }
    return false;
  }

  static Future<bool> postUserInfo(User user) async {
    try {
      final response = await http.post(
        Uri.parse("$https/member/join"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user),
      );
      if (response.statusCode != 200) {
        throw Exception("Failed to join");
      } else {
        return true;
      }
    } catch (e) {
      print("postUserInfo: Failed to get response: $e");
    }
    return false;
  }

  static Future<String?> queryNearCourse() async {
    try {
      //Trail
      var response = await http.post(
        Uri.parse("$https/notVisitedTrail"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data == "farTrail") {
          print(data);
          return data;
        }
      }

      //Hiking
      response = await http.post(
        Uri.parse("$https/notVisitedHiking"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data == "farHiking") {
          print(data);
          return data;
        }
      }

      //Park
      response = await http.post(
        Uri.parse("$https/notVisitedPark"),
        headers: {"Content-Type": "application/json"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data == "farPark") {
          print(data);
          return data;
        }
      }
    } catch (e) {
      print("queryNearCourse: Failed to get response: $e");
    }
    return "nearCourse";
  }

  dynamic queryAddress(Position p) async { //날씨, 대략적 주소
    try {
      String endpoint = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc";
      String output = "json";
      String orders = "addr";
      String longtitude = p.longitude.toString();
      String latitude = p.latitude.toString();

      http.Response response = await http.get(
        Uri.parse("$endpoint?coords=$longtitude,$latitude&output=$output&orders=$orders"),
        headers: {
          "X-NCP-APIGW-API-KEY-ID" : naverId,
          "X-NCP-APIGW-API-KEY" : naverKey,
        },
      );

      if (response.statusCode == 200) {
        var json = jsonDecode(response.body)['results'][1]['area'];
        var area1 = json['area1']['name'];
        var area2 = json['area2']['name'];
        var area3 = json['area3']['name'];

        return "$area1 $area2 $area3";

      } else {
        print("Failed to get address: ${response.statusCode}");
      }
    }
    catch (e) {
      print("Failed to get response: $e");
    }

    return null;
  }

  Future<List> queryUsageStats(DateTime startDate, DateTime endDate) async { //앱 사용 정보 수신
    int now = DateTime.now().millisecondsSinceEpoch;
    int end = endDate.millisecondsSinceEpoch;
    int start = startDate.millisecondsSinceEpoch;
    Map<String, int> interval = {'start': start, 'end': end};

    List queryUsageStats = await _channel.invokeMethod('queryUsageStats', interval);
    List usageInfos = [];
    for (var map in queryUsageStats) {
      if (int.parse(map['totalTimeInForeground']) > 0) {
        map.remove('firstTimeStamp');
        map.remove('lastTimeStamp');
        map['id'] = "${user?.id}";
        map['nowTimeStamp'] = now.toString();

        //usageInfos.add(map);
        usageInfos.add(map);
      }
    }
    /*
    for (var info in usageInfos){
      print("usageName: ${info["packageName"]}");
    }
    */
    return usageInfos;
  }

  Future<List> postUsageStats(DateTime startDate, DateTime endDate) async { //앱 사용 정보 백엔드 송신
    var usageInfos = await queryUsageStats(startDate, endDate);
    //var data = List.generate(usageInfos.length, generator)
    var body = jsonEncode(usageInfos);

    try {
      final response = await http.post(
        Uri.parse("$https/appInfo"),
        headers: {"Content-Type": "application/json"}, // 필수
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return data;
      } else {
        print("Failed to post usage stats: ${response.statusCode}");
      }
    }
    catch (e) {
      print("Failed to get response: $e");
    }

    return [];
  }

  /*
  Future<List> queryCarbon(String id, DateTime startDate, DateTime endDate) async {
    var usageInfos = queryUsageStats(startDate, endDate);
    var body = jsonEncode(usageInfos);

    try {
      http.Response response = await http.post(
        Uri.parse("$https/appInfo"),
        headers: {"Content-Type": "application/json"}, // 필수
        body: body,
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;

        return data;
      } else {
        print("Failed to post usage stats: ${response.statusCode}");
      }
    }
    catch (e) {
      print("Failed to get response: $e");
    }

    return [];
  }
  */

  Future<List> queryCarbonYesterday() async {
    try {
      http.Response response = await http.post(
        Uri.parse("$https/appInfoYesterday"),
        headers: {"Content-Type": "application/json"}, // 필수
        body: jsonEncode(user),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        return data;
      } else {
        print("Failed to get carbon yesterday data: ${response.statusCode}");
      }
    }
    catch (e) {
      print("queryCarbonYesterday: Failed to get response: $e");
    }

    return [];
  }

  Future<List> queryCarbonChange() async {
    try {
      http.Response response = await http.post(
        Uri.parse("$https/appInfoChange"),
        headers: {"Content-Type": "application/json"}, // 필수
        body: jsonEncode(user),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('queryCarbonChange: $data');
        return data;
      } else {
        print("Failed to get carbon change data: ${response.statusCode}");
      }
    }
    catch (e) {
      print("queryCarbonChange: Failed to get response: $e");
    }

    return [];
  }

  Future<dynamic> queryCarbonDailyStats() async {
    try {
      http.Response response = await http.post(
        Uri.parse("$https/statistics"),
        headers: {"Content-Type": "application/json"}, // 필수
        body: jsonEncode(user),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map;
        return data;
      } else {
        print("Failed to get carbon daily stats: ${response.statusCode}");
      }
    }
    catch (e) {
      print("queryCarbonDailyStats: Failed to get response: $e");
    }
    return null;
  }

  Future<List> queryCarbonWeeklyStats() async {
    try {
      http.Response response = await http.post(
        Uri.parse("$https/statistics7days"),
        headers: {"Content-Type": "application/json"}, // 필수
        body: jsonEncode(user),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('queryCarbonWeeklyStats: $data');
        return data;
      } else {
        print("Failed to get carbon weekly stats: ${response.statusCode}");
      }
    }
    catch (e) {
      print("queryCarbonWeeklyStats: Failed to get response: $e");
    }
    return [];
  }

  Future<double> queryCarbonBaseValue() async {
    try {
      http.Response response = await http.post(
        Uri.parse("$https/userBaseValue"),
        headers: {"Content-Type": "application/json"}, // 필수
        body: jsonEncode(user),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        print('queryCarbonBaseValue: $data');
        return data;
      } else {
        print("Failed to get carbon base value: ${response.statusCode}");
      }
    }
    catch (e) {
      print("queryCarbonBaseValue: Failed to get response: $e");
    }
    return 0;
  }

  Future<dynamic> queryCarbonInObj() async { //사용된 탄소 -> 주행 거리, 나무 개수
    try {
      http.Response response = await http.post(
        Uri.parse("$https/carbonInObj"),
        headers: {"Content-Type": "application/json"}, // 필수
        body: jsonEncode(user),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map;
        print('queryCarbonInObj: $data');
        return data;
      } else {
        print("Failed to get carbon in objects: ${response.statusCode}");
      }
    }
    catch (e) {
      print("queryCarbonInObj: Failed to get response: $e");
    }
    return null;
  }

  Future<bool> postCoordinates(LocationData l) async {
    try {
      final response = await http.post(
        Uri.parse("$https/coordinates"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": user?.id,
          "nowLatitude": l.latitude,
          "nowLongitude": l.longitude
        }),
      );
      if (response.statusCode != 200) {
        throw Exception("Failed to post coordinates");
      } else {
        return true;
      }
    } catch (e) {
      print("postCoordinates: Failed to get response: $e");
    }
    return false;
  }

  Future<WalkingInfo> getWalkingInfo(User? user) async {
    try {
      final response = await http.post(
        Uri.parse("$https/startWalk"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user),
      );
      if (response.statusCode != 200) {
        throw Exception("Failed to get walking info: ${response.statusCode}");
      } else {
        if (response == null) {
          return WalkingInfo(
            name: "null",
            time: "null",
            distance: "null",
            details: ["null"]
          );
        } else {

        }
        final data = json.decode(utf8.decode(response.bodyBytes));
        final place = data["place"];
        String tag = place.keys.toList()[0];

        Map<String, dynamic> entity = place[tag]; //수정?

        /*
        VisitedTrailEntity:  ‘’’{"lnk_nam":"애국의숲길","cos_nam":"관악산둘레길","cos_num":"1코스","comment":"","len_tim":"←2시간30분 6.2Km→", "leng_lnk":"6729.79251047","cos_lvl":"","cat_nam":"둘레길링크"}’’’
        VisitedHikingEntity: '''{"up_min":"3","down_min":"2","mntn_nm":"배봉산","sec_len":"180","cat_nam":"하"}'''
        VisitedParkEntity: '''{"park_name":"수리산"}'''
        */

        if (tag == "trail") {
          List<String> parts = entity["lenTim"].split(" ");
          String time; String distance;
          if (parts.length == 2){
            time = parts[0];
            distance = parts[1];
          } else {
            time = "${parts[0]} ${parts[1]}";
            distance = parts[2];
          }

          List<String> details = [];
          if (entity["cosNum"] != null) details.add("코스번호: ${entity["cosNum"]}");
          //if (entity["cosLvl"] != null) details.add("난이도: ${entity["cosLvl"]}");

          var temp = WalkingInfo(
              name: entity["cosNam"],
              time: time,
              distance: distance,
            details: details
          );
          return temp;
        }
        if (tag == "hiking") {
          int time = int.parse(entity["upMin"]) + int.parse(entity["downMin"]);

          var temp = WalkingInfo(
          name: entity["mntnNm"],
          time: "$time분",
          distance: entity["secLen"],
            details: ["none"]//["난이도: ${entity["catNam"]}"]
          );
          return temp;
        }
        if (tag == "park") {
          var temp = WalkingInfo(
            name: entity["parkName"],
            time: "none",
            distance: "none",
            details: ["none"]
          );
          return temp;
        }
      }
    } catch (e) {
      print("getWalkingInfo: Failed to get response: $e");
    }
    return WalkingInfo(
        name: "null",
        time: "null",
        distance: "null",
        details: ["null"]
    );
  }

  Future<dynamic> postWalkingReport(Duration totalTime, int totalCnt) async {
    try {
      final response = await http.post(
        Uri.parse("$https/endWalk"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": user?.id,
          "totalWalkTime": totalTime.inMilliseconds,
          "totalDistractionCnt": totalCnt
        }),
      );
      if (response.statusCode != 200) {
        throw Exception("Failed to post walking report");
      } else {
        final data = json.decode(response.body) ?? {"car": 0, "tree": 0}; //수정?
        return data;
      }
    } catch (e) {
      print("postWalkingReport: Failed to get response: $e");
      return {"car": 0, "tree": 0};
    }
  }

  Future<List> getWalkingRanking() async {
    try {
      final response = await http.post(
        Uri.parse("$https/rankingTop10"),
        headers: {"Content-Type": "application/json"},
      );
      if (response.statusCode != 200) {
        throw Exception("Failed to get walking ranking");
      } else {
        final data = json.decode(response.body) ?? [];
        return data;
      }
    } catch (e) {
      print("getWalkingRanking: Failed to get response: $e");
    }
    return [];
  }
}
import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:usage_stats/usage_stats.dart';
import '../data/user.dart';

class Service {
  static const https = "https://6590-219-255-43-158.ngrok-free.app";
  static const MethodChannel _channel = MethodChannel('usage_stats');

  static const naverId = "apsz5g7nue";
  static const naverKey = "E4QCjVeH5c4MTYKUVIHM1QLK7Z96qyLzU2fB50my";

  dynamic queryAddress(Position p) async {
    try {
      String endpoint = "https://naveropenapi.apigw.ntruss.com/map-reversegeocode/v2/gc";
      String output = "json";
      String orders = "addr";
      String longtitude = p.longitude.toString();
      String latitude = p.latitude.toString();

      http.Response response = await get(
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

  Future<List> queryUsageStats(DateTime startDate, DateTime endDate) async {
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
        map['id'] = "sample";
        map['nowTimeStamp'] = now.toString();
        print(map['lastTimeUsed'].runtimeType);
        print(map['lastTimeUsed']);
        print(map['nowTimeStamp']);
        print(map['totalTimeInForeground']);
        usageInfos.add(map);
      }
    }
    return usageInfos;
  }

  Future<List<dynamic>> postUsageStats(String id, DateTime startDate, DateTime endDate) async {
    /*
    List sample =[
      {
        "firstTimeStamp": "1712203495982",
        "lastTimeStamp": "1712289895981",
        "lastTimeUsed": "0",
        "packageName": "google.android.sample3",
        "totalTimeInForeground": "10"
      },
      {
        "firstTimeStamp": "1712203495982",
        "lastTimeStamp": "1712289895981",
        "lastTimeUsed": "0",
        "packageName": "google.android.sample4",
        "totalTimeInForeground": "20"
      }
    ];
    var body = jsonEncode(sample);
    */
    var usageInfos = queryUsageStats(startDate, endDate);
    var body = jsonEncode(usageInfos);

    try {
      http.Response response = await http.post(
        Uri.parse("$https/usageStats"),
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

  Future<User?> queryUserInfoId(String id) async {
    try {
      final response = await http.get(
          Uri.parse("$https/member/$id"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        return User(
          id: data['id'],
          password: data['password'],
          name: data['name'],
          birthdate: data['birthdate'],
        );
      }
    } catch (e) {
      print("Failed to get response: $e");
    }
    return null;
  }

  Future<bool> postUserInfo(User user) async {
    try {
      final response = await http.post(
        Uri.parse("$https/member/join"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(user.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception("Failed to register");
      }
      return true;
    } catch (e) {
      print("Failed to get response: $e");
    }
    return false;
  }
}
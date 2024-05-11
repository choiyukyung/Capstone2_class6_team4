import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:usage_stats/usage_stats.dart';
import '../data/user.dart';

class Service {
  static const MethodChannel _channel = MethodChannel('usage_stats');
  List<EventUsageInfo> usageInfo = [];

  Future<int> queryCarbon() async {
    try {
      http.Response response = await http.get(
        Uri.parse("http:/127.0.0.1:3306/carbon?when=today"),
      );

      if (response.statusCode == 200) {
        int carbon = (jsonDecode(response.body))['carbon'];
        return carbon;
      }
    } catch (e) {
      print("Failed to get response: $e");
    }
    return -1;
  }

  Future<List<dynamic>> getUsageStats(DateTime startDate, DateTime endDate, String id) async {
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
    print(usageInfos);
    var body = jsonEncode(usageInfos);

    try {
      http.Response response = await http.post(
        Uri.parse("https://6590-219-255-43-158.ngrok-free.app/usageStats"),
        headers: {"Content-Type": "application/json"}, // 필수
        body: body,
      );

      if (response.statusCode != 200) {
        print("Failed to post usage stats: ${response.statusCode}");
      }
    }
    catch (e) {
      print("Failed to get response: $e");
    }

    //List<UsageInfo> result =
    //queryUsageStats.map((item) => UsageInfo.fromMap(item)).toList();
    return usageInfos;
  }

  Future<User?> searchUser(String id) async {
    try {
      final response = await http.get(
          Uri.parse("http://127.0.0.1:3306/member/$id"));
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

  Future<bool> saveUser(User user) async {
    try {
      final response = await http.post(
        Uri.parse("http://127.0.0.1:3306/member/join"),
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
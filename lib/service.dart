import 'dart:async';
import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:tuple/tuple.dart';
import 'package:usage_stats/usage_stats.dart';
import './User.dart';

class Service {
  static const MethodChannel _channel = MethodChannel('usage_stats');
  List<EventUsageInfo> usageInfo = [];

  Future<Tuple2<List<UsageInfo>,int>?> queryUsageCarbon(DateTime startDate, DateTime endDate) async {
    int end = endDate.millisecondsSinceEpoch;
    int start = startDate.millisecondsSinceEpoch;
    Map<String, int> interval = {'start': start, 'end': end};

    //json 리스트 전송
    List usageStats = await _channel.invokeMethod('queryUsageStats', interval);
    var body = jsonEncode(usageStats); // 인코딩

    try {
      /*
      http.Response response = await http.post(
        Uri.parse('엔드포인트 주소'),
        headers: {"Content-Type": "application/json"}, // 필수
        body: body,
      );
      int carbon = (jsonDecode(response.body))['carbon'];

      if (response.statusCode == 200) {
        int carbon = 0;
        List<UsageInfo> result =
        usageStats.map((item) => UsageInfo.fromMap(item)).toList();
        return Tuple2(result, carbon);
      }
      */
      int carbon = 0;
      List<UsageInfo> result =
      usageStats.map((item) => UsageInfo.fromMap(item)).toList();
      result.removeWhere((i) => int.parse(i.totalTimeInForeground!) == 0);
      return Tuple2(result, carbon);
    }
    catch (e) {
      print("Failed to get response: $e");
    }
    return null;
  }

  Future<User?> searchUser(String id) async {
    try {
      final response = await http.get(
          Uri.parse("http://localhost:58010/member/$id"));
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
        Uri.parse("http://localhost:58010/member/join"),
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
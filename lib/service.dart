import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './User.dart';

class Service{
  Future<User?> searchUser (String id) async{
    try {
      final response = await http.get(Uri.parse("http://localhost:58010/member/search?id=$id"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        print("User Data sent successfully");
        return User(
          id: data['id'],
          password: data['password'],
          name: data['name'],
          birthdate: data['birthdate'],
        );
      } else {
        return null;
      }
    } catch (e) {
      print("Failed to fetch post by id: $e");
      return null;
    }
  }

  Future<bool> saveUser(User user) async {
    try {
      final response = await http.post(
        Uri.parse("http://localhost:58010/member/join"),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: jsonEncode(user.toJson()),
      );
      if (response.statusCode != 200) {
        throw Exception("Failed to send data");
      } else {
        print("User Data sent successfully");
        return true;
        //Get.to(const HomePage());
      }
    } catch (e) {
      print("Failed to send user data: $e");
      return false;
    }
  }
}
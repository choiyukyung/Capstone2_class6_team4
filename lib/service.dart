import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart' as http;
import './User.dart';

class Service{
  Future<User?> searchUser (String email) async{
    try {
      final response = await http.get(Uri.parse("http://server-uri/user/search?email=$email"));
      if (response.statusCode == 200) {
        final data = json.decode(response.body) as Map<String, dynamic>;
        print("User Data sent successfully");
        return User(
            email: data['email'],
            password: data['password'],
        );
      } else {
        return null;
      }
    } catch (e) {
      print("Failed to fetch post by email: $e");
      return null;
    }
  }

  Future<bool> saveUser(User user) async {
    try {
      final response = await http.post(
        Uri.parse("http://server-uri/user/save"),
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
import 'dart:convert';

import 'package:expense_tracker/models/init_shered_pref.dart';
import 'package:http/http.dart' as http;

class AuthServices {
  // http://localhost:8080/api/v1/auth/login
  // http://localhost:8080/api/v1/auth/register
  //192.168.1.5
  static const baseUrl = "http://10.75.51.65:8080/api/v1/auth";

  static Future<bool> register({
    required String first_name,
    required String last_name,
    required String email,
    required String password,
  }) async {
    try {
      final uri = "$baseUrl/register";
      final url = Uri.parse(uri);
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          'first_name': first_name,
          'last_name': last_name,
          'email': email,
          'password': password,
        }),
      );
      print(response);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        final data = jsonDecode(body);
        final token = data["token"];
        await InitSheredPref.instance.setToken(token);
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      return false;
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final uri = "$baseUrl/login";
      final url = Uri.parse(uri);
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({'email': email, 'password': password}),
      );
      print(" Login response:--- ${response.body}");
      if (response.statusCode == 200 || response.statusCode == 201) {
        final body = response.body;
        final data = jsonDecode(body);
        return data;
      } else {
        return {"error": "somthing want wrong"};
      }
    } catch (e) {
      print("Login error:- ${e.toString()}");
      return {"error": e.toString()};
    }
  }
}

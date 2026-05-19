import 'dart:convert';

import 'package:expense_tracker/models/init_shered_pref.dart';
import 'package:http/http.dart' as http;

class AuthServices {
  static const baseUrl = "http://10.0.2.2:8080/api/v1/auth";

  static Future<Map<String, dynamic>> register({
    required String first_name,
    required String last_name,
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/register");
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({
              'first_name': first_name,
              'last_name': last_name,
              'email': email,
              'password': password,
            }),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final token = data['data']?['token'] as String?;
        if (token != null) await InitSheredPref.instance.setToken(token);
        return data;
      } else {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }

  static Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final url = Uri.parse("$baseUrl/login");
      final response = await http
          .post(
            url,
            headers: {"Content-Type": "application/json"},
            body: jsonEncode({'email': email, 'password': password}),
          )
          .timeout(const Duration(seconds: 10));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body) as Map<String, dynamic>;
        final token = data['data']?['token'] as String?;
        if (token != null) await InitSheredPref.instance.setToken(token);
        return data;
      } else {
        return jsonDecode(response.body) as Map<String, dynamic>;
      }
    } catch (e) {
      return {'success': false, 'message': e.toString()};
    }
  }
}

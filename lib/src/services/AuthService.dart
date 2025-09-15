import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class AuthService {
  static const String _baseUrl =
      'https://gateway-production-7c45.up.railway.app/auth-service/auth';

  // Login Method
  Future<void> login(String username, String password) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'username': username, 'password': password}),
    );

    if (response.statusCode == 200) {
      final token = jsonDecode(response.body)['accessToken'];
      SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString('accessToken', token); // Guarda el token
    } else {
      throw Exception('Login failed: ${response.body}');
    }
  }

  // Register Method
  Future<void> register(
    String username,
    String password,
    String whatsapp,
    String email,
  ) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': username,
        'password': password,
        'whatsapp': whatsapp,
        'email': email,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to register: ${response.body}');
    }
  }

  // Get Token
  Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('accessToken');
  }

  // Logout Method
  Future<void> logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('accessToken');
  }
}

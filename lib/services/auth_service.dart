import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app_config.dart';
import '../provider/auth_provider.dart';

class AuthService {
  final AuthProvider auth;
  AuthService(this.auth);

  Future<Map<String, dynamic>> login(String email, String password) async {
    try {
      final res = await http.post(
        Uri.parse("${AppConfig.baseUrl}/auth/login"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({"email": email, "password": password}),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        await auth.setUser(
          data['token'],
          data['role'],
          data['name'],
          data['id'],
        );
        return {"success": true, "role": data['role']};
      }
      return {"success": false, "message": data['message'] ?? "Login failed"};
    } catch (e) {
      return {"success": false, "message": "Could not reach the server!"};
    }
  }

  Future<Map<String, dynamic>> register(
    String name, String email, String password, String role,
    {String phone = "", String skills = "", String company = "", String bio = ""}
  ) async {
    try {
      final res = await http.post(
        Uri.parse("${AppConfig.baseUrl}/auth/register"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "name": name,
          "email": email,
          "password": password,
          "role": role,
          "phone": phone,
          "skills": skills,
          "company": company,
          "bio": bio,
        }),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 201 || res.statusCode == 200) {
        return {"success": true};
      }
      return {"success": false, "message": data['message'] ?? "Register failed"};
    } catch (e) {
      return {"success": false, "message": "Could not reach the server."};
    }
  }
}

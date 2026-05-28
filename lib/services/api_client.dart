import 'dart:convert';
import 'package:http/http.dart' as http;
import '../app_config.dart';
import '../provider/auth_provider.dart';

class ApiClient {
  final AuthProvider auth;
  ApiClient(this.auth);

  Map<String, String> _headers() {
    return {
      "Content-Type": "application/json",
      if (auth.token != null) "Authorization": "Bearer ${auth.token}",
    };
  }

  Future<http.Response> get(String path) async {
    return await http.get(
      Uri.parse("${AppConfig.baseUrl}$path"),
      headers: _headers(),
    );
  }

  Future<http.Response> post(String path, dynamic body) async {
    return await http.post(
      Uri.parse("${AppConfig.baseUrl}$path"),
      headers: _headers(),
      body: jsonEncode(body),
    );
  }

  Future<http.Response> put(String path, dynamic body) async {
    return await http.put(
      Uri.parse("${AppConfig.baseUrl}$path"),
      headers: _headers(),
      body: jsonEncode(body),
    );
  }

  Future<http.Response> delete(String path) async {
    return await http.delete(
      Uri.parse("${AppConfig.baseUrl}$path"),
      headers: _headers(),
    );
  }
}

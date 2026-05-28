import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  String? _role;
  String? _name;
  int? _userId;

  String? get token => _token;
  String? get role => _role;
  String? get name => _name;
  int? get userId => _userId;
  bool get isLoggedIn => _token != null;

  Future<void> setUser(String token, String role, String name, int userId) async {
    final prefs = await SharedPreferences.getInstance();
    _token = token;
    _role = role;
    _name = name;
    _userId = userId;
    await prefs.setString('token', token);
    await prefs.setString('role', role);
    await prefs.setString('name', name);
    await prefs.setInt('userId', userId);
    notifyListeners();
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token = prefs.getString('token');
    _role = prefs.getString('role');
    _name = prefs.getString('name');
    _userId = prefs.getInt('userId');
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    _token = null;
    _role = null;
    _name = null;
    _userId = null;
    await prefs.clear();
    notifyListeners();
  }
}

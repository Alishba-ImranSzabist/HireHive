import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider extends ChangeNotifier {
  String? _token;
  String? _role;
  String? _name;
  int?    _userId;
  String? _email;
  String? _phone;
  String? _skills;
  String? _company;
  String? _bio;
  String? _imageUrl;

  String? get token    => _token;
  String? get role     => _role;
  String? get name     => _name;
  int?    get userId   => _userId;
  String? get email    => _email;
  String? get phone    => _phone;
  String? get skills   => _skills;
  String? get company  => _company;
  String? get bio      => _bio;
  String? get imageUrl => _imageUrl;
  bool    get isLoggedIn => _token != null;

  Future<void> setUser({
    required String token,
    required String role,
    required String name,
    required int    userId,
    String email   = '',
    String phone   = '',
    String skills  = '',
    String company = '',
    String bio     = '',
    String imageUrl = '',
  }) async {
    final prefs = await SharedPreferences.getInstance();
    _token    = token;
    _role     = role;
    _name     = name;
    _userId   = userId;
    _email    = email;
    _phone    = phone;
    _skills   = skills;
    _company  = company;
    _bio      = bio;
    _imageUrl = imageUrl;

    await prefs.setString('token',    token);
    await prefs.setString('role',     role);
    await prefs.setString('name',     name);
    await prefs.setInt   ('userId',   userId);
    await prefs.setString('email',    email);
    await prefs.setString('phone',    phone);
    await prefs.setString('skills',   skills);
    await prefs.setString('company',  company);
    await prefs.setString('bio',      bio);
    await prefs.setString('imageUrl', imageUrl);
    notifyListeners();
  }

  // Update only image URL locally (after upload)
  Future<void> updateImageUrl(String url) async {
    final prefs = await SharedPreferences.getInstance();
    _imageUrl = url;
    await prefs.setString('imageUrl', url);
    notifyListeners();
  }

  // Update profile fields locally (after PUT /users/:id)
  Future<void> updateProfile({
    required String name,
    required String phone,
    required String skills,
    required String company,
    required String bio,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    _name    = name;
    _phone   = phone;
    _skills  = skills;
    _company = company;
    _bio     = bio;
    await prefs.setString('name',    name);
    await prefs.setString('phone',   phone);
    await prefs.setString('skills',  skills);
    await prefs.setString('company', company);
    await prefs.setString('bio',     bio);
    notifyListeners();
  }

  Future<void> loadToken() async {
    final prefs = await SharedPreferences.getInstance();
    _token    = prefs.getString('token');
    _role     = prefs.getString('role');
    _name     = prefs.getString('name');
    _userId   = prefs.getInt('userId');
    _email    = prefs.getString('email')    ?? '';
    _phone    = prefs.getString('phone')    ?? '';
    _skills   = prefs.getString('skills')   ?? '';
    _company  = prefs.getString('company')  ?? '';
    _bio      = prefs.getString('bio')      ?? '';
    _imageUrl = prefs.getString('imageUrl') ?? '';
    notifyListeners();
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    _token = _role = _name = _email = _phone = _skills = _company = _bio = _imageUrl = null;
    _userId = null;
    await prefs.clear();
    notifyListeners();
  }
}

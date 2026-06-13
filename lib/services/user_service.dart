import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:path/path.dart' as p;
import '../app_config.dart';
import '../provider/auth_provider.dart';

class UserService {
  final AuthProvider auth;
  UserService(this.auth);

  Map<String, String> get _headers => {
    "Content-Type": "application/json",
    "Authorization": "Bearer ${auth.token}",
  };

  // ── Update profile text fields ──────────────────────────────────────────
  Future<Map<String, dynamic>> updateProfile({
    required String name,
    required String phone,
    required String skills,
    required String company,
    required String bio,
  }) async {
    try {
      final res = await http.put(
        Uri.parse("${AppConfig.baseUrl}/users/${auth.userId}"),
        headers: _headers,
        body: jsonEncode({
          "name": name, "phone": phone,
          "skills": skills, "company": company, "bio": bio,
        }),
      );
      final data = jsonDecode(res.body);
      if (res.statusCode == 200) {
        // Update local state
        await auth.updateProfile(
          name: name, phone: phone,
          skills: skills, company: company, bio: bio,
        );
        return {"success": true};
      }
      return {"success": false, "message": data['message'] ?? "Update failed"};
    } catch (e) {
      return {"success": false, "message": "Could not reach the server!"};
    }
  }

  // ── Upload profile image ────────────────────────────────────────────────
  Future<Map<String, dynamic>> uploadProfileImage(File imageFile) async {
    try {
      final ext = p.extension(imageFile.path).toLowerCase().replaceAll('.', '');
      final mimeType = ext == 'png' ? 'png' : 'jpeg';

      final request = http.MultipartRequest(
        'POST',
        Uri.parse("${AppConfig.baseUrl}/users/${auth.userId}/image"),
      );
      request.headers['Authorization'] = "Bearer ${auth.token}";
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        imageFile.path,
        contentType: MediaType('image', mimeType),
      ));

      final streamedResponse = await request.send();
      final res = await http.Response.fromStream(streamedResponse);
      final data = jsonDecode(res.body);

      if (res.statusCode == 200) {
        await auth.updateImageUrl(data['image_url']);
        return {"success": true, "image_url": data['image_url']};
      }
      return {"success": false, "message": data['message'] ?? "Upload failed"};
    } catch (e) {
      return {"success": false, "message": "Image upload failed!"};
    }
  }
}

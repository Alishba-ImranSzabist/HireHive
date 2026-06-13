import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import '../../services/user_service.dart';
import '../common/welcome_screen.dart';

class ClientProfileScreen extends StatefulWidget {
  @override
  _ClientProfileScreenState createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {
  bool _uploadingImage = false;

  Future<void> _pickAndUploadImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery, imageQuality: 80, maxWidth: 600);
    if (picked == null) return;
    setState(() => _uploadingImage = true);
    final result = await UserService(context.read<AuthProvider>()).uploadProfileImage(File(picked.path));
    setState(() => _uploadingImage = false);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(result['success'] ? "Profile photo updated!" : (result['message'] ?? "Upload failed")),
      backgroundColor: result['success'] ? Colors.green : Colors.red,
    ));
  }

  void _openEditDialog() {
    final auth        = context.read<AuthProvider>();
    final nameCtrl    = TextEditingController(text: auth.name    ?? '');
    final phoneCtrl   = TextEditingController(text: auth.phone   ?? '');
    final companyCtrl = TextEditingController(text: auth.company ?? '');
    final bioCtrl     = TextEditingController(text: auth.bio     ?? '');
    bool saving = false;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDlg) => AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: Text("Edit Profile", style: TextStyle(color: Color(0xFF021A54), fontWeight: FontWeight.bold)),
          content: SingleChildScrollView(
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              _field(nameCtrl,    "Full Name",    Icons.person_outline),
              SizedBox(height: 12),
              _field(phoneCtrl,   "Phone",        Icons.phone_outlined, type: TextInputType.phone),
              SizedBox(height: 12),
              _field(companyCtrl, "Company",      Icons.business_outlined),
              SizedBox(height: 12),
              TextField(
                controller: bioCtrl, maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Bio", prefixIcon: Icon(Icons.info_outline),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ]),
          ),
          actions: [
            TextButton(onPressed: () => Navigator.pop(ctx), child: Text("Cancel")),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF021A54), foregroundColor: Colors.white),
              onPressed: saving ? null : () async {
                if (nameCtrl.text.trim().isEmpty) return;
                setDlg(() => saving = true);
                final result = await UserService(auth).updateProfile(
                  name: nameCtrl.text.trim(), phone: phoneCtrl.text.trim(),
                  skills: auth.skills ?? '', company: companyCtrl.text.trim(), bio: bioCtrl.text.trim(),
                );
                setDlg(() => saving = false);
                Navigator.pop(ctx);
                setState(() {});
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(result['success'] ? "Profile updated!" : (result['message'] ?? "Failed")),
                  backgroundColor: result['success'] ? Colors.green : Colors.red,
                ));
              },
              child: saving
                  ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Text("Save"),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final hasImage = auth.imageUrl != null && auth.imageUrl!.isNotEmpty;

    return SingleChildScrollView(
      child: Column(
        children: [
          // ── Header Banner ──────────────────────────────────────────────
          Container(
            width: double.infinity,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF021A54), Color(0xFF0D3080)],
                begin: Alignment.topLeft, end: Alignment.bottomRight,
              ),
            ),
            child: Column(
              children: [
                SizedBox(height: 36),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 3),
                        boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 10)],
                      ),
                      child: CircleAvatar(
                        radius: 52,
                        backgroundColor: Colors.white24,
                        backgroundImage: hasImage ? NetworkImage(auth.imageUrl!) : null,
                        child: !hasImage ? Icon(Icons.business_outlined, size: 50, color: Colors.white) : null,
                      ),
                    ),
                    GestureDetector(
                      onTap: _uploadingImage ? null : _pickAndUploadImage,
                      child: Container(
                        padding: EdgeInsets.all(7),
                        decoration: BoxDecoration(
                          color: Colors.white, shape: BoxShape.circle,
                          boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                        ),
                        child: _uploadingImage
                            ? SizedBox(width: 14, height: 14, child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF021A54)))
                            : Icon(Icons.camera_alt_outlined, size: 16, color: Color(0xFF021A54)),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14),
                Text(auth.name ?? 'Your Name',
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white)),
                SizedBox(height: 6),
                Text(auth.email ?? '', style: TextStyle(color: Colors.white70, fontSize: 13)),
                SizedBox(height: 10),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 16, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.white38),
                  ),
                  child: Text("Client", style: TextStyle(color: Colors.white, fontSize: 13, fontWeight: FontWeight.w600)),
                ),
                SizedBox(height: 28),
              ],
            ),
          ),

          // ── Info Cards ──────────────────────────────────────────────────
          Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("Profile Info", style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey[600])),
                SizedBox(height: 12),

                _infoCard(Icons.person_outline,    "Full Name", auth.name    ?? 'Not set'),
                _infoCard(Icons.email_outlined,    "Email",     auth.email   ?? 'Not set'),
                _infoCard(Icons.phone_outlined,    "Phone",     (auth.phone   ?? '').isEmpty ? 'Not set' : auth.phone!),
                _infoCard(Icons.business_outlined, "Company",   (auth.company ?? '').isEmpty ? 'Not set' : auth.company!),
                _infoCard(Icons.info_outline,      "Bio",       (auth.bio     ?? '').isEmpty ? 'Not set' : auth.bio!),
                _infoCard(Icons.badge_outlined,    "User ID",   auth.userId?.toString() ?? 'Not set'),

                SizedBox(height: 28),

                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton.icon(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(0xFF021A54), foregroundColor: Colors.white,
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      elevation: 0,
                    ),
                    icon: Icon(Icons.edit_outlined),
                    label: Text("Edit Profile", style: TextStyle(fontSize: 15)),
                    onPressed: _openEditDialog,
                  ),
                ),
                SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: OutlinedButton.icon(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: Colors.red, side: BorderSide(color: Colors.red),
                      padding: EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    ),
                    icon: Icon(Icons.logout_outlined),
                    label: Text("Logout", style: TextStyle(fontSize: 15)),
                    onPressed: () async {
                      await context.read<AuthProvider>().logout();
                      Navigator.pushAndRemoveUntil(context,
                          MaterialPageRoute(builder: (_) => WelcomeScreen()), (r) => false);
                    },
                  ),
                ),
                SizedBox(height: 20),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _field(TextEditingController c, String label, IconData icon, {TextInputType? type}) {
    return TextField(
      controller: c, keyboardType: type,
      decoration: InputDecoration(
        labelText: label, prefixIcon: Icon(icon),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
      ),
    );
  }

  Widget _infoCard(IconData icon, String label, String value) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.03), blurRadius: 6, offset: Offset(0, 2))],
      ),
      child: Row(children: [
        Container(
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Color(0xFF021A54).withOpacity(0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Color(0xFF021A54), size: 18),
        ),
        SizedBox(width: 14),
        Expanded(child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[500], fontWeight: FontWeight.w500)),
            SizedBox(height: 2),
            Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500, color: Colors.black87)),
          ],
        )),
      ]),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import '../common/welcome_screen.dart';

class ClientProfileScreen extends StatefulWidget {
  @override
  _ClientProfileScreenState createState() => _ClientProfileScreenState();
}

class _ClientProfileScreenState extends State<ClientProfileScreen> {

  void _openEditDialog() {
    final auth = context.read<AuthProvider>();
    final nameController = TextEditingController(text: auth.name ?? '');

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit Profile", style: TextStyle(color: Color(0xFF021A54), fontWeight: FontWeight.bold)),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  prefixIcon: Icon(Icons.person),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF021A54)),
            onPressed: () async {
              final auth = context.read<AuthProvider>();
              await auth.setUser(
                auth.token!,
                auth.role!,
                nameController.text,
                auth.userId!,
              );
              setState(() {});
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Profile updated!"), backgroundColor: Colors.green),
              );
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final name = auth.name ?? '';

    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 10),

          CircleAvatar(
            radius: 45,
            backgroundColor: Color(0xFF021A54),
            child: Icon(Icons.business, size: 45, color: Colors.white),
          ),
          SizedBox(height: 15),

          Text(
            name.isEmpty ? "Your Name" : name,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),

          Chip(
            label: Text("Client", style: TextStyle(color: Colors.white)),
            backgroundColor: Color(0xFF021A54),
          ),
          SizedBox(height: 20),

          _infoCard(Icons.person, "Name", name.isEmpty ? "Not set" : name),
          _infoCard(Icons.badge, "User ID", auth.userId?.toString() ?? "Not set"),

          SizedBox(height: 20),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF021A54),
                padding: EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: Icon(Icons.edit),
              label: Text("Edit Profile", style: TextStyle(fontSize: 15)),
              onPressed: _openEditDialog,
            ),
          ),
          SizedBox(height: 12),

          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
                side: BorderSide(color: Colors.red),
                padding: EdgeInsets.symmetric(vertical: 13),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: Icon(Icons.logout),
              label: Text("Logout", style: TextStyle(fontSize: 15)),
              onPressed: () async {
                await context.read<AuthProvider>().logout();
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (_) => WelcomeScreen()),
                  (route) => false,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _infoCard(IconData icon, String label, String value) {
    return Container(
      width: double.infinity,
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, color: Color(0xFF021A54), size: 20),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: TextStyle(fontSize: 12, color: Colors.grey)),
                Text(value, style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

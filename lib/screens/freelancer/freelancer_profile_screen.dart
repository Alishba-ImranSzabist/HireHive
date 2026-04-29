

// Profile info show + Edit button

import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../common/welcome_screen.dart';

class FreelancerProfileScreen extends StatefulWidget {
  @override
  _FreelancerProfileScreenState createState() => _FreelancerProfileScreenState();
}

class _FreelancerProfileScreenState extends State<FreelancerProfileScreen> {

  // Edit dialog open
  void _openEditDialog() {
    // Controllers mein current data loading
    final nameController    = TextEditingController(text: currentUser.name);
    final phoneController   = TextEditingController(text: currentUser.phone);
    final skillsController  = TextEditingController(text: currentUser.skills);
    final bioController     = TextEditingController(text: currentUser.bio);

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
              SizedBox(height: 12),
              TextField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: "Phone",
                  prefixIcon: Icon(Icons.phone),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: skillsController,
                decoration: InputDecoration(
                  labelText: "Skills",
                  prefixIcon: Icon(Icons.star),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                ),
              ),
              SizedBox(height: 12),
              TextField(
                controller: bioController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Bio",
                  prefixIcon: Icon(Icons.info),
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
            onPressed: () {
              // Global currentUser update karo
              setState(() {
                currentUser.name   = nameController.text;
                currentUser.phone  = phoneController.text;
                currentUser.skills = skillsController.text;
                currentUser.bio    = bioController.text;
              });
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
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        children: [
          SizedBox(height: 10),

          // Avatar
          CircleAvatar(
            radius: 45,
            backgroundColor: Color(0xFF021A54),
            child: Icon(Icons.person, size: 50, color: Colors.white),
          ),
          SizedBox(height: 15),

          // Name
          Text(
            currentUser.name.isEmpty ? "Your Name" : currentUser.name,
            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 5),

          // Role badge
          Chip(
            label: Text("Freelancer", style: TextStyle(color: Colors.white)),
            backgroundColor: Color(0xFF021A54),
          ),
          SizedBox(height: 20),

          // Info cards
          _infoCard(Icons.email,  "Email",  currentUser.email.isEmpty  ? "Not set" : currentUser.email),
          _infoCard(Icons.phone,  "Phone",  currentUser.phone.isEmpty  ? "Not set" : currentUser.phone),
          _infoCard(Icons.star,   "Skills", currentUser.skills.isEmpty ? "Not set" : currentUser.skills),
          _infoCard(Icons.info,   "Bio",    currentUser.bio.isEmpty    ? "Not set" : currentUser.bio),

          SizedBox(height: 20),

          // EDIT PROFILE button
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

          // LOGOUT button
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
              onPressed: () {
                currentUser = UserModel(role: "freelancer");
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
                Text(value,  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

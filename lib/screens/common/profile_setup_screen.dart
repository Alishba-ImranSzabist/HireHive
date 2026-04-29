


// Role ke hisaab se alag fields dikhaye
// Constructor recieve from role

import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import '../freelancer/freelancer_home.dart';
import '../client/client_home.dart';

class ProfileSetupScreen extends StatefulWidget {
  final String role; // constructor se recieve

  ProfileSetupScreen({required this.role});

  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final bioController = TextEditingController();
  final skillsController = TextEditingController();   // freelancer only
  final companyController = TextEditingController();  // client only

  @override
  void initState() {
    super.initState();
    //load if this save at the first time save
    nameController.text = currentUser.name;
    phoneController.text = currentUser.phone;
    bioController.text = currentUser.bio;
    skillsController.text = currentUser.skills;
    companyController.text = currentUser.company;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Setup Profile"),

        //donotb need back button  for profile setup
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Role badge
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFF021A54).withOpacity(0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: Color(0xFF021A54)),
              ),
              child: Text(
                widget.role == "freelancer" ? "👨‍💻 Freelancer Profile" : "🏢 Client Profile",
                style: TextStyle(color: Color(0xFF021A54), fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 20),

            Text("Complete your profile", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            SizedBox(height: 5),
            Text("This helps others know about you", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 25),

            // Name
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Full Name",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 15),

            // Phone
            TextField(
              controller: phoneController,
              keyboardType: TextInputType.phone,
              decoration: InputDecoration(
                labelText: "Phone Number",
                prefixIcon: Icon(Icons.phone),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 15),

            // Freelancer: Skills field
            if (widget.role == "freelancer")
              Column(
                children: [
                  TextField(
                    controller: skillsController,
                    decoration: InputDecoration(
                      labelText: "Your Skills (e.g. Flutter, UI Design)",
                      prefixIcon: Icon(Icons.star),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),

            // Client: Company field
            if (widget.role == "client")
              Column(
                children: [
                  TextField(
                    controller: companyController,
                    decoration: InputDecoration(
                      labelText: "Company Name",
                      prefixIcon: Icon(Icons.business),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                  ),
                  SizedBox(height: 15),
                ],
              ),

            // Bio
            TextField(
              controller: bioController,
              maxLines: 3,
              decoration: InputDecoration(
                labelText: "Short Bio",
                prefixIcon: Icon(Icons.info),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 30),

            // Save & Continue Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  // Global user mein save
                  currentUser.role = widget.role;
                  currentUser.name = nameController.text;
                  currentUser.phone = phoneController.text;
                  currentUser.bio = bioController.text;
                  currentUser.skills = skillsController.text;
                  currentUser.company = companyController.text;

                  // Role  base navigate
                  if (widget.role == "freelancer") {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => FreelancerHome()),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => ClientHome()),
                    );
                  }
                },
                child: Text("Save & Continue", style: TextStyle(fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

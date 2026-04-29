


// Bottom nav: Jobs | Applications | Profile
// setState se tab switch

import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'freelancer_jobs_screen.dart';
import 'freelancer_applications_screen.dart';
import 'freelancer_profile_screen.dart';

class FreelancerHome extends StatefulWidget {
  @override
  _FreelancerHomeState createState() => _FreelancerHomeState();
}

class _FreelancerHomeState extends State<FreelancerHome> {
  int currentIndex = 0;

  // Screens list
  final List<Widget> screens = [
    FreelancerJobsScreen(),
    FreelancerApplicationsScreen(),
    FreelancerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Hello, ${currentUser.name.isEmpty ? 'Freelancer' : currentUser.name}"),
        automaticallyImplyLeading: false,
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: currentIndex,
        selectedItemColor: Color(0xFF021A54),
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.work), label: "Jobs"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt), label: "Applications"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

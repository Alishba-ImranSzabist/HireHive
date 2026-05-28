import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import 'freelancer_jobs_screen.dart';
import 'freelancer_applications_screen.dart';
import 'freelancer_profile_screen.dart';

class FreelancerHome extends StatefulWidget {
  @override
  _FreelancerHomeState createState() => _FreelancerHomeState();
}

class _FreelancerHomeState extends State<FreelancerHome> {
  int currentIndex = 0;

  final List<Widget> screens = [
    FreelancerJobsScreen(),
    FreelancerApplicationsScreen(),
    FreelancerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final name = auth.name ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text("Hello, ${name.isEmpty ? 'Freelancer' : name}"),
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

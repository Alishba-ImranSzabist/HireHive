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
  int _currentIndex = 0;

  final List<Widget> _screens = [
    FreelancerJobsScreen(),
    FreelancerApplicationsScreen(),
    FreelancerProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Hello, ${auth.name?.isEmpty == true ? 'Freelancer' : auth.name ?? 'Freelancer'}"),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF021A54),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xFF021A54),
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.work_outline),      activeIcon: Icon(Icons.work),      label: "Jobs"),
          BottomNavigationBarItem(icon: Icon(Icons.list_alt_outlined),  activeIcon: Icon(Icons.list_alt),  label: "Applications"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline),     activeIcon: Icon(Icons.person),    label: "Profile"),
        ],
      ),
    );
  }
}

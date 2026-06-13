import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import 'client_jobs_screen.dart';
import 'client_applications_screen.dart';
import 'post_job_screen.dart';
import 'client_profile_screen.dart';

class ClientHome extends StatefulWidget {
  @override
  _ClientHomeState createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    ClientJobsScreen(),
    ClientApplicationsScreen(),
    PostJobScreen(),
    ClientProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text("Hello, ${auth.name?.isEmpty == true ? 'Client' : auth.name ?? 'Client'}"),
        automaticallyImplyLeading: false,
        backgroundColor: Color(0xFF021A54),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _currentIndex,
        selectedItemColor: Color(0xFF021A54),
        unselectedItemColor: Colors.grey,
        onTap: (i) => setState(() => _currentIndex = i),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.work_outline),         activeIcon: Icon(Icons.work),         label: "My Jobs"),
          BottomNavigationBarItem(icon: Icon(Icons.people_outline),       activeIcon: Icon(Icons.people),       label: "Applicants"),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle_outline),   activeIcon: Icon(Icons.add_circle),   label: "Post Job"),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline),       activeIcon: Icon(Icons.person),       label: "Profile"),
        ],
      ),
    );
  }
}

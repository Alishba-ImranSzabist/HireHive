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
  int currentIndex = 0;

  final List<Widget> screens = [
    ClientJobsScreen(),
    ClientApplicationsScreen(),
    PostJobScreen(),
    ClientProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthProvider>();
    final name = auth.name ?? '';

    return Scaffold(
      appBar: AppBar(
        title: Text("Hello, ${name.isEmpty ? 'Client' : name}"),
        automaticallyImplyLeading: false,
      ),
      body: screens[currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: currentIndex,
        selectedItemColor: Color(0xFF021A54),
        unselectedItemColor: Colors.grey,
        onTap: (index) => setState(() => currentIndex = index),
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.work), label: "My Jobs"),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: "Applicants"),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: "Post Job"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

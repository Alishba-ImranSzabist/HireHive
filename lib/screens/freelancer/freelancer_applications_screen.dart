

// Freelancer ki applications + status
// Accepted ho  then chat open

import 'package:flutter/material.dart';
import '../common/chat_page.dart';

class FreelancerApplicationsScreen extends StatelessWidget {

  // Dummy applications
  final List<Map<String, String>> applications = [
    {"job": "Flutter App Development", "client": "Ali Enterprises", "status": "Accepted"},
    {"job": "Website Design", "client": "Sara Ltd", "status": "Pending"},
    {"job": "Logo Design", "client": "Ahmed Corp", "status": "Pending"},
  ];

  @override
  Widget build(BuildContext context) {
    return applications.isEmpty
        ? Center(child: Text("No applications yet", style: TextStyle(color: Colors.grey)))
        : ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: applications.length,
            itemBuilder: (context, index) {
              final app = applications[index];
              final isAccepted = app["status"] == "Accepted";

              return Card(
                margin: EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: ListTile(
                  contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                  leading: CircleAvatar(
                    backgroundColor: isAccepted
                        ? Colors.green.withOpacity(0.1)
                        : Colors.orange.withOpacity(0.1),
                    child: Icon(
                      isAccepted ? Icons.check_circle : Icons.access_time,
                      color: isAccepted ? Colors.green : Colors.orange,
                    ),
                  ),
                  title: Text(app["job"]!, style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text("Client: ${app["client"]}", style: TextStyle(color: Colors.grey)),
                  trailing: isAccepted
                      ? ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          ),
                          icon: Icon(Icons.chat, size: 16),
                          label: Text("Chat", style: TextStyle(fontSize: 12)),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => ChatPage(partnerName: app["client"]!),
                              ),
                            );
                          },
                        )
                      : Chip(
                          label: Text("Pending", style: TextStyle(fontSize: 12, color: Colors.orange)),
                          backgroundColor: Colors.orange.withOpacity(0.1),
                        ),
                ),
              );
            },
          );
  }
}

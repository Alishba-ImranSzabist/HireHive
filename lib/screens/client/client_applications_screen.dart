
// Accept → Chat button recieve
// Reject → wapas Pending

import 'package:flutter/material.dart';
import '../common/chat_page.dart';

class ClientApplicationsScreen extends StatefulWidget {
  @override
  _ClientApplicationsScreenState createState() =>
      _ClientApplicationsScreenState();
}

class _ClientApplicationsScreenState
    extends State<ClientApplicationsScreen> {

  // Dummy applications
  List<Map<String, String>> applications = [
    {"freelancer": "Ahmed Khan", "job": "Flutter App Development", "status": "pending"},
    {"freelancer": "Sara Malik", "job": "Website Design",          "status": "pending"},
    {"freelancer": "Ali Hassan", "job": "Logo Design",             "status": "accepted"},
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
              final status = app["status"]!;

              return Card(
                margin: EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Padding(
                  padding: EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Top row: avatar + name + status chip
                      Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Color(0xFF021A54).withOpacity(0.1),
                            child: Icon(Icons.person, color: Color(0xFF021A54)),
                          ),
                          SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  app["freelancer"]!,
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                                ),
                                Text(
                                  "Applied for: ${app["job"]}",
                                  style: TextStyle(color: Colors.grey, fontSize: 12),
                                ),
                              ],
                            ),
                          ),

                          // Status chip
                          Chip(
                            label: Text(
                              status == "accepted" ? "Accepted" : "Pending",
                              style: TextStyle(
                                fontSize: 11,
                                color: status == "accepted" ? Colors.green : Colors.orange,
                              ),
                            ),
                            backgroundColor: status == "accepted"
                                ? Colors.green.withOpacity(0.1)
                                : Colors.orange.withOpacity(0.1),
                            padding: EdgeInsets.zero,
                          ),
                        ],
                      ),
                      SizedBox(height: 12),

                      // Bottom row: action buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [

                          // PENDING → show Accept button
                          if (status == "pending")
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF021A54),
                                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              ),
                              icon: Icon(Icons.check, size: 16),
                              label: Text("Accept", style: TextStyle(fontSize: 13)),
                              onPressed: () {
                                setState(() {
                                  applications[index]["status"] = "accepted";
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("${app["freelancer"]} accepted!"),
                                    backgroundColor: Colors.green,
                                  ),
                                );
                              },
                            ),

                          // ACCEPTED → show Chat + Reject buttons
                          if (status == "accepted") ...[
                            // Chat button
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Color(0xFF021A54),
                                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              ),
                              icon: Icon(Icons.chat, size: 16),
                              label: Text("Chat", style: TextStyle(fontSize: 13)),
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => ChatPage(partnerName: app["freelancer"]!),
                                  ),
                                );
                              },
                            ),
                            SizedBox(width: 8),

                            // Reject / Undo button
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: Colors.red,
                                side: BorderSide(color: Colors.red),
                                padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                              ),
                              icon: Icon(Icons.close, size: 16),
                              label: Text("Reject", style: TextStyle(fontSize: 13)),
                              onPressed: () {
                                // Wapas pending  — setState se
                                setState(() {
                                  applications[index]["status"] = "pending";
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text("${app["freelancer"]} marked as pending again."),
                                    backgroundColor: Colors.orange,
                                  ),
                                );
                              },
                            ),
                          ],
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}

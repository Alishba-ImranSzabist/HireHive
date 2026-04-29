

// Job  detail — constructor se job recieve
// Role base button change

import 'package:flutter/material.dart';
import '../../models/job_model.dart';
import 'chat_page.dart';

class JobDetailScreen extends StatelessWidget {
  final JobModel job;   // constructor se recieve
  final String role;    // "freelancer" ya "client"

  JobDetailScreen({required this.job, required this.role});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Job Detail")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // Job Title
            Text(
              job.title,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Color(0xFF021A54),
              ),
            ),
            SizedBox(height: 10),

            // Posted by
            Row(
              children: [
                Icon(Icons.business, size: 16, color: Colors.grey),
                SizedBox(width: 5),
                Text("Posted by: ${job.postedBy}", style: TextStyle(color: Colors.grey)),
              ],
            ),
            SizedBox(height: 15),


            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color(0xFF021A54).withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xFF021A54).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.monetization_on, color: Color(0xFF021A54)),
                  SizedBox(width: 10),
                  Text(
                    "Budget: Rs. ${job.budget}",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF021A54),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Description
            Text("Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              job.description,
              style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.5),
            ),
            SizedBox(height: 40),

            // Button —  role base
            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                icon: Icon(role == "freelancer" ? Icons.send : Icons.chat),
                label: Text(
                  role == "freelancer" ? "Apply & Chat with Client" : "Message Freelancer",
                  style: TextStyle(fontSize: 15),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ChatPage(
                        partnerName: role == "freelancer" ? job.postedBy : "Freelancer",
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

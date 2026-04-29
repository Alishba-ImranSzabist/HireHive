

// Client job post karta hai
// Form → add in allJobs list

import 'package:flutter/material.dart';
import '../../models/job_model.dart';
import '../../models/user_model.dart';

class PostJobScreen extends StatefulWidget {
  @override
  _PostJobScreenState createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final titleController = TextEditingController();
  final budgetController = TextEditingController();
  final descController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(height: 10),
          Text("Post a New Job", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF021A54))),
          SizedBox(height: 5),
          Text("Fill the details below to post your job", style: TextStyle(color: Colors.grey)),
          SizedBox(height: 25),

          // Job Title
          TextField(
            controller: titleController,
            decoration: InputDecoration(
              labelText: "Job Title",
              hintText: "e.g. Flutter App Developer",
              prefixIcon: Icon(Icons.work),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 15),

          // Budget
          TextField(
            controller: budgetController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Budget (Rs.)",
              hintText: "e.g. 50000",
              prefixIcon: Icon(Icons.monetization_on),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 15),

          // Description
          TextField(
            controller: descController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: "Job Description",
              hintText: "Describe what you need...",
              prefixIcon: Icon(Icons.description),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 30),

          // Post Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: Icon(Icons.send),
              label: Text("Post Job", style: TextStyle(fontSize: 16)),
              onPressed: () {
                if (titleController.text.isEmpty || budgetController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please fill all required fields!"), backgroundColor: Colors.red),
                  );
                  return;
                }

                // Global list mein add
                allJobs.add(JobModel(
                  title: titleController.text,
                  budget: budgetController.text,
                  description: descController.text.isEmpty ? "No description" : descController.text,
                  postedBy: currentUser.name.isEmpty ? "Anonymous Client" : currentUser.name,
                ));

                // Fields clear
                titleController.clear();
                budgetController.clear();
                descController.clear();

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Job posted successfully!"), backgroundColor: Colors.green),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

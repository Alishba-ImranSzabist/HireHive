

// Client ki posted jobs — Edit + Delete

import 'package:flutter/material.dart';
import '../../models/job_model.dart';
import '../common/job_detail_screen.dart';

class ClientJobsScreen extends StatefulWidget {
  @override
  _ClientJobsScreenState createState() => _ClientJobsScreenState();
}

class _ClientJobsScreenState extends State<ClientJobsScreen> {

  // DELETE function
  void _deleteJob(int index) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Delete Job"),
        content: Text("Are you sure you want to delete this job?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                allJobs.removeAt(index); // list clean
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Job deleted!"), backgroundColor: Colors.red),
              );
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  // EDIT function — dialog open
  void _editJob(int index) {
    final titleController = TextEditingController(text: allJobs[index].title);
    final budgetController = TextEditingController(text: allJobs[index].budget);
    final descController = TextEditingController(text: allJobs[index].description);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit Job", style: TextStyle(color: Color(0xFF021A54))),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: titleController,
                decoration: InputDecoration(
                  labelText: "Job Title",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: budgetController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: "Budget (Rs.)",
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: descController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: "Description",
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context), // Cancel
            child: Text("Cancel"),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF021A54)),
            onPressed: () {
              // Global list update  — setState se UI refresh
              setState(() {
                allJobs[index] = JobModel(
                  title: titleController.text,
                  budget: budgetController.text,
                  description: descController.text,
                  postedBy: allJobs[index].postedBy,
                );
              });
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text("Job updated!"), backgroundColor: Colors.green),
              );
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return allJobs.isEmpty
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.work_off, size: 60, color: Colors.grey[300]),
                SizedBox(height: 10),
                Text("No jobs posted yet", style: TextStyle(color: Colors.grey)),
                Text("Go to Post Job tab!", style: TextStyle(color: Colors.grey, fontSize: 12)),
              ],
            ),
          )
        : ListView.builder(
            padding: EdgeInsets.all(10),
            itemCount: allJobs.length,
            itemBuilder: (context, index) {
              final job = allJobs[index];
              return Card(
                margin: EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                child: Column(
                  children: [
                    // Job info row
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: Color(0xFF021A54).withOpacity(0.1),
                        child: Icon(Icons.work, color: Color(0xFF021A54)),
                      ),
                      title: Text(
                        job.title,
                        style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF021A54)),
                      ),
                      subtitle: Text(
                        "Rs. ${job.budget}",
                        style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600),
                      ),
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => JobDetailScreen(job: job, role: "client"),
                          ),
                        );
                      },
                    ),

                    // Edit + Delete buttons
                    Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          // EDIT button
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Color(0xFF021A54),
                              side: BorderSide(color: Color(0xFF021A54)),
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            ),
                            icon: Icon(Icons.edit, size: 16),
                            label: Text("Edit", style: TextStyle(fontSize: 13)),
                            onPressed: () => _editJob(index),
                          ),
                          SizedBox(width: 10),

                          // DELETE button
                          OutlinedButton.icon(
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.red,
                              side: BorderSide(color: Colors.red),
                              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            ),
                            icon: Icon(Icons.delete, size: 16),
                            label: Text("Delete", style: TextStyle(fontSize: 13)),
                            onPressed: () => _deleteJob(index),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
  }
}

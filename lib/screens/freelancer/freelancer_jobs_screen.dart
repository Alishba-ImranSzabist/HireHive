

// Saari jobs list + search
// Job tap → JobDetailScreen (constructor se)

import 'package:flutter/material.dart';
import '../../models/job_model.dart';
import '../common/job_detail_screen.dart';

class FreelancerJobsScreen extends StatefulWidget {
  @override
  _FreelancerJobsScreenState createState() => _FreelancerJobsScreenState();
}

class _FreelancerJobsScreenState extends State<FreelancerJobsScreen> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    // Search filter
    List<JobModel> filteredJobs = allJobs
        .where((job) => job.title.toLowerCase().contains(searchQuery.toLowerCase()))
        .toList();

    return Column(
      children: [

        // Search bar
        Padding(
          padding: EdgeInsets.all(12),
          child: TextField(
            onChanged: (value) => setState(() => searchQuery = value),
            decoration: InputDecoration(
              hintText: "Search jobs...",
              prefixIcon: Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[100],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),

        // Jobs count
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 15),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "${filteredJobs.length} jobs available",
              style: TextStyle(color: Colors.grey, fontSize: 13),
            ),
          ),
        ),
        SizedBox(height: 5),

        // Jobs list
        Expanded(
          child: filteredJobs.isEmpty
              ? Center(child: Text("No jobs found", style: TextStyle(color: Colors.grey)))
              : ListView.builder(
                  itemCount: filteredJobs.length,
                  itemBuilder: (context, index) {
                    final job = filteredJobs[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      elevation: 2,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                        leading: CircleAvatar(
                          backgroundColor: Color(0xFF021A54).withOpacity(0.1),
                          child: Icon(Icons.work, color: Color(0xFF021A54)),
                        ),
                        title: Text(
                          job.title,
                          style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF021A54)),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(height: 3),
                            Text("Rs. ${job.budget}", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                            Text(job.postedBy, style: TextStyle(color: Colors.grey, fontSize: 12)),
                          ],
                        ),
                        trailing: Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
                        // Constructor se data pass — sir ka style
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => JobDetailScreen(job: job, role: "freelancer"),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

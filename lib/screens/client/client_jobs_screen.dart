import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/job_model.dart';
import '../../provider/auth_provider.dart';
import '../../services/api_client.dart';
import '../../services/job_service.dart';
import '../common/job_detail_screen.dart';

class ClientJobsScreen extends StatefulWidget {
  @override
  _ClientJobsScreenState createState() => _ClientJobsScreenState();
}

class _ClientJobsScreenState extends State<ClientJobsScreen> {
  List<JobModel> jobs = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadJobs();
  }

  void loadJobs() async {
    final auth = context.read<AuthProvider>();
    final service = JobService(ApiClient(auth));
    try {
      final data = await service.fetchJobs();
      setState(() { jobs = data; loading = false; });
    } catch (e) {
      setState(() => loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load jobs."), backgroundColor: Colors.red),
      );
    }
  }

  void _deleteJob(JobModel job) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Delete Job"),
        content: Text("Are you sure you want to delete this job?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final auth = context.read<AuthProvider>();
              final success = await JobService(ApiClient(auth)).deleteJob(job.id!);
              if (success) {
                setState(() => jobs.remove(job));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Job deleted successfully. "), backgroundColor: Colors.red),
                );
              }
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _editJob(JobModel job) {
    final titleController = TextEditingController(text: job.title);
    final budgetController = TextEditingController(text: job.budget);
    final descController = TextEditingController(text: job.description);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Edit Job", style: TextStyle(color: Color(0xFF021A54))),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleController, decoration: InputDecoration(labelText: "Job Title", border: OutlineInputBorder())),
              SizedBox(height: 10),
              TextField(controller: budgetController, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Budget (Rs.)", border: OutlineInputBorder())),
              SizedBox(height: 10),
              TextField(controller: descController, maxLines: 3, decoration: InputDecoration(labelText: "Description", border: OutlineInputBorder())),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF021A54)),
            onPressed: () async {
              Navigator.pop(context);
              final updated = JobModel(
                id: job.id,
                title: titleController.text,
                budget: budgetController.text,
                description: descController.text,
                postedBy: job.postedBy,
              );
              final auth = context.read<AuthProvider>();
              final success = await JobService(ApiClient(auth)).updateJob(job.id!, updated);
              if (success) {
                loadJobs();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Job updated Successfully"), backgroundColor: Colors.green),
                );
              }
            },
            child: Text("Save"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Center(child: CircularProgressIndicator());
    if (jobs.isEmpty) return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work_off, size: 60, color: Colors.grey[300]),
          SizedBox(height: 10),
          Text("No jobs available right now", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );
    return RefreshIndicator(
      onRefresh: () async => loadJobs(),
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(0xFF021A54).withOpacity(0.1),
                    child: Icon(Icons.work, color: Color(0xFF021A54)),
                  ),
                  title: Text(job.title, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF021A54))),
                  subtitle: Text("Rs. ${job.budget}", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => JobDetailScreen(job: job, role: "client"))),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(foregroundColor: Color(0xFF021A54), side: BorderSide(color: Color(0xFF021A54))),
                        icon: Icon(Icons.edit, size: 16),
                        label: Text("Edit"),
                        onPressed: () => _editJob(job),
                      ),
                      SizedBox(width: 10),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: BorderSide(color: Colors.red)),
                        icon: Icon(Icons.delete, size: 16),
                        label: Text("Delete"),
                        onPressed: () => _deleteJob(job),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

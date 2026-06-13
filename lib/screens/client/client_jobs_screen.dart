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
  List<JobModel> _jobs = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadJobs();
  }

  void _loadJobs() async {
    try {
      final auth = context.read<AuthProvider>();
      final data = await JobService(ApiClient(auth)).fetchJobs();
      setState(() { _jobs = data; _loading = false; });
    } catch (_) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load jobs."), backgroundColor: Colors.red),
      );
    }
  }

  void _showDeleteDialog(JobModel job) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Delete Job"),
        content: Text("Are you sure you want to delete \"${job.title}\"?"),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              final auth = context.read<AuthProvider>();
              final success = await JobService(ApiClient(auth)).deleteJob(job.id!);
              if (success) {
                setState(() => _jobs.remove(job));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Job deleted."), backgroundColor: Colors.red),
                );
              }
            },
            child: Text("Delete", style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(JobModel job) {
    final titleCtrl  = TextEditingController(text: job.title);
    final budgetCtrl = TextEditingController(text: job.budget);
    final descCtrl   = TextEditingController(text: job.description);

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        title: Text("Edit Job", style: TextStyle(color: Color(0xFF021A54))),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(controller: titleCtrl,  decoration: InputDecoration(labelText: "Job Title",      border: OutlineInputBorder())),
              SizedBox(height: 10),
              TextField(controller: budgetCtrl, keyboardType: TextInputType.number, decoration: InputDecoration(labelText: "Budget (Rs.)", border: OutlineInputBorder())),
              SizedBox(height: 10),
              TextField(controller: descCtrl,   maxLines: 3, decoration: InputDecoration(labelText: "Description",  border: OutlineInputBorder())),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text("Cancel")),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: Color(0xFF021A54), foregroundColor: Colors.white),
            onPressed: () async {
              Navigator.pop(context);
              final auth    = context.read<AuthProvider>();
              final updated = JobModel(id: job.id, title: titleCtrl.text, budget: budgetCtrl.text, description: descCtrl.text, postedBy: job.postedBy);
              final success = await JobService(ApiClient(auth)).updateJob(job.id!, updated);
              if (success) {
                _loadJobs();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text("Job updated."), backgroundColor: Colors.green),
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
    if (_loading) return Center(child: CircularProgressIndicator());

    if (_jobs.isEmpty) return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.work_off_outlined, size: 64, color: Colors.grey[300]),
          SizedBox(height: 12),
          Text("No jobs posted yet", style: TextStyle(color: Colors.grey)),
        ],
      ),
    );

    return RefreshIndicator(
      onRefresh: () async => _loadJobs(),
      child: ListView.builder(
        padding: EdgeInsets.all(12),
        itemCount: _jobs.length,
        itemBuilder: (context, index) {
          final job = _jobs[index];
          return Card(
            margin: EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 1,
            child: Column(
              children: [
                ListTile(
                  leading: CircleAvatar(
                    backgroundColor: Color(0xFF021A54).withOpacity(0.1),
                    child: Icon(Icons.work_outline, color: Color(0xFF021A54)),
                  ),
                  title: Text(job.title, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF021A54))),
                  subtitle: Text("Rs. ${job.budget}", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => JobDetailScreen(job: job, role: "client"))),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(12, 0, 12, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(foregroundColor: Color(0xFF021A54), side: BorderSide(color: Color(0xFF021A54))),
                        icon: Icon(Icons.edit_outlined, size: 16),
                        label: Text("Edit"),
                        onPressed: () => _showEditDialog(job),
                      ),
                      SizedBox(width: 10),
                      OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(foregroundColor: Colors.red, side: BorderSide(color: Colors.red)),
                        icon: Icon(Icons.delete_outline, size: 16),
                        label: Text("Delete"),
                        onPressed: () => _showDeleteDialog(job),
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

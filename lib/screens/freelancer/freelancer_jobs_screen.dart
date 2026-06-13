import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/job_model.dart';
import '../../provider/auth_provider.dart';
import '../../services/api_client.dart';
import '../../services/job_service.dart';
import '../common/job_detail_screen.dart';

class FreelancerJobsScreen extends StatefulWidget {
  @override
  _FreelancerJobsScreenState createState() => _FreelancerJobsScreenState();
}

class _FreelancerJobsScreenState extends State<FreelancerJobsScreen> {
  List<JobModel> _allJobs = [];
  String _searchQuery = "";
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
      setState(() { _allJobs = data; _loading = false; });
    } catch (_) {
      setState(() => _loading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load jobs."), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) return Center(child: CircularProgressIndicator());

    final filtered = _allJobs
        .where((j) => j.title.toLowerCase().contains(_searchQuery.toLowerCase()))
        .toList();

    return Column(
      children: [
        Padding(
          padding: EdgeInsets.fromLTRB(12, 12, 12, 6),
          child: TextField(
            onChanged: (v) => setState(() => _searchQuery = v),
            decoration: InputDecoration(
              hintText: "Search jobs...",
              prefixIcon: Icon(Icons.search),
              filled: true,
              fillColor: Colors.grey[100],
              contentPadding: EdgeInsets.symmetric(vertical: 0),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text("${filtered.length} jobs available", style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          ),
        ),
        Expanded(
          child: filtered.isEmpty
              ? Center(child: Text("No jobs found.", style: TextStyle(color: Colors.grey)))
              : RefreshIndicator(
                  onRefresh: () async => _loadJobs(),
                  child: ListView.builder(
                    padding: EdgeInsets.all(12),
                    itemCount: filtered.length,
                    itemBuilder: (context, index) {
                      final job = filtered[index];
                      return Card(
                        margin: EdgeInsets.symmetric(vertical: 5),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 1,
                        child: ListTile(
                          contentPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                          leading: CircleAvatar(
                            backgroundColor: Color(0xFF021A54).withOpacity(0.1),
                            child: Icon(Icons.work_outline, color: Color(0xFF021A54)),
                          ),
                          title: Text(job.title, style: TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF021A54))),
                          subtitle: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(height: 3),
                              Text("Rs. ${job.budget}", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                              Text(job.postedBy, style: TextStyle(color: Colors.grey, fontSize: 12)),
                            ],
                          ),
                          trailing: Icon(Icons.chevron_right, color: Colors.grey),
                          onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(builder: (_) => JobDetailScreen(job: job, role: "freelancer")),
                          ),
                        ),
                      );
                    },
                  ),
                ),
        ),
      ],
    );
  }
}

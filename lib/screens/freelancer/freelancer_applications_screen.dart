import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import '../../services/api_client.dart';
import '../../services/application_service.dart';

class FreelancerApplicationsScreen extends StatefulWidget {
  @override
  _FreelancerApplicationsScreenState createState() => _FreelancerApplicationsScreenState();
}

class _FreelancerApplicationsScreenState extends State<FreelancerApplicationsScreen> {
  List<dynamic> applications = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadApplications();
  }

  void loadApplications() async {
    final auth = context.read<AuthProvider>();
    final data = await ApplicationService(ApiClient(auth)).fetchMyApplications();
    setState(() { applications = data; loading = false; });
  }

  Color _statusColor(String status) {
    if (status == 'accepted') return Colors.green;
    if (status == 'rejected') return Colors.red;
    return Colors.orange;
  }

  IconData _statusIcon(String status) {
    if (status == 'accepted') return Icons.check_circle;
    if (status == 'rejected') return Icons.cancel;
    return Icons.access_time;
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Center(child: CircularProgressIndicator());

    if (applications.isEmpty) return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.list_alt, size: 60, color: Colors.grey[300]),
          SizedBox(height: 10),
          Text("There are no applications right now.", style: TextStyle(color: Colors.grey)),
          SizedBox(height: 5),
          Text("View jobs and apply.", style: TextStyle(color: Colors.grey, fontSize: 12)),
        ],
      ),
    );

    return RefreshIndicator(
      onRefresh: () async => loadApplications(),
      child: ListView.builder(
        padding: EdgeInsets.all(10),
        itemCount: applications.length,
        itemBuilder: (context, index) {
          final app = applications[index];
          final status = app['status'] ?? 'pending';

          return Card(
            margin: EdgeInsets.symmetric(vertical: 6),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
              leading: CircleAvatar(
                backgroundColor: _statusColor(status).withOpacity(0.1),
                child: Icon(_statusIcon(status), color: _statusColor(status)),
              ),
              title: Text(app['job_title'] ?? '', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 3),
                  Text("Rs. ${app['budget']}", style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600)),
                  Text("Client: ${app['posted_by']}", style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              trailing: Chip(
                label: Text(
                  status == 'accepted' ? "Accepted" : status == 'rejected' ? "Rejected" : "Pending",
                  style: TextStyle(fontSize: 11, color: _statusColor(status)),
                ),
                backgroundColor: _statusColor(status).withOpacity(0.1),
              ),
            ),
          );
        },
      ),
    );
  }
}

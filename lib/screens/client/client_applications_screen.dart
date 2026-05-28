import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import '../../services/api_client.dart';
import '../../services/application_service.dart';

class ClientApplicationsScreen extends StatefulWidget {
  @override
  _ClientApplicationsScreenState createState() => _ClientApplicationsScreenState();
}

class _ClientApplicationsScreenState extends State<ClientApplicationsScreen> {
  List<dynamic> applications = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    loadApplications();
  }

  void loadApplications() async {
    final auth = context.read<AuthProvider>();
    final data = await ApplicationService(ApiClient(auth)).fetchClientApplications();
    setState(() { applications = data; loading = false; });
  }

  void _updateStatus(int appId, String status, int index) async {
    final auth = context.read<AuthProvider>();
    final success = await ApplicationService(ApiClient(auth)).updateStatus(appId, status);
    if (success) {
      setState(() => applications[index]['status'] = status);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            status == 'accepted'
                ? "Application accepted successfully!"
                : "Application rejected successfully!",
          ),
          backgroundColor:
          status == 'accepted' ? Colors.green : Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (loading) return Center(child: CircularProgressIndicator());

    if (applications.isEmpty) return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.people, size: 60, color: Colors.grey[300]),
          SizedBox(height: 10),
          Text("No applications received yet.", style: TextStyle(color: Colors.grey)),
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
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

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
                            Text(app['freelancer_name'] ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
                            Text("Applied for: ${app['job_title']}", style: TextStyle(color: Colors.grey, fontSize: 12)),
                            Text(app['freelancer_email'] ?? '', style: TextStyle(color: Colors.grey, fontSize: 11)),
                          ],
                        ),
                      ),
                      // Status chip
                      Chip(
                        label: Text(
                          status == 'accepted' ? "Accepted" : status == 'rejected' ? "Rejected" : "Pending",
                          style: TextStyle(
                            fontSize: 11,
                            color: status == 'accepted' ? Colors.green : status == 'rejected' ? Colors.red : Colors.orange,
                          ),
                        ),
                        backgroundColor: (status == 'accepted' ? Colors.green : status == 'rejected' ? Colors.red : Colors.orange).withOpacity(0.1),
                        padding: EdgeInsets.zero,
                      ),
                    ],
                  ),
                  SizedBox(height: 12),

                  // Action buttons — sirf pending par dikhen
                  if (status == 'pending')
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton.icon(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.green,
                            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          ),
                          icon: Icon(Icons.check, size: 16),
                          label: Text("Accept", style: TextStyle(fontSize: 13)),
                          onPressed: () => _updateStatus(app['id'], 'accepted', index),
                        ),
                        SizedBox(width: 8),
                        OutlinedButton.icon(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.red,
                            side: BorderSide(color: Colors.red),
                            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                          ),
                          icon: Icon(Icons.close, size: 16),
                          label: Text("Reject", style: TextStyle(fontSize: 13)),
                          onPressed: () => _updateStatus(app['id'], 'rejected', index),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

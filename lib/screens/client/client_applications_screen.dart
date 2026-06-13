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
  List<dynamic> _applications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final auth = context.read<AuthProvider>();
    final data = await ApplicationService(ApiClient(auth)).fetchClientApplications();
    setState(() { _applications = data; _loading = false; });
  }

  void _updateStatus(int appId, String status, int index) async {
    final auth    = context.read<AuthProvider>();
    final success = await ApplicationService(ApiClient(auth)).updateStatus(appId, status);
    if (success) {
      setState(() => _applications[index]['status'] = status);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(status == 'accepted' ? "Application accepted." : "Application rejected."),
        backgroundColor: status == 'accepted' ? Colors.green : Colors.red,
      ));
    }
  }

  Color _statusColor(String s) {
    if (s == 'accepted') return Colors.green;
    if (s == 'rejected') return Colors.red;
    return Colors.orange;
  }

  IconData _statusIcon(String s) {
    if (s == 'accepted') return Icons.check_circle_outline;
    if (s == 'rejected') return Icons.cancel_outlined;
    return Icons.access_time_outlined;
  }

  String _statusLabel(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  Widget build(BuildContext context) {
    if (_loading) return Center(child: CircularProgressIndicator(color: Color(0xFF021A54)));

    if (_applications.isEmpty) return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(color: Color(0xFF021A54).withOpacity(0.06), shape: BoxShape.circle),
          child: Icon(Icons.people_outline, size: 52, color: Color(0xFF021A54).withOpacity(0.4)),
        ),
        SizedBox(height: 16),
        Text("No Applications Yet", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
        SizedBox(height: 6),
        Text("Applications will appear here once\nfreelancers apply to your jobs.",
            textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 13)),
      ]),
    );

    // Stats summary
    final total    = _applications.length;
    final accepted = _applications.where((a) => a['status'] == 'accepted').length;
    final pending  = _applications.where((a) => a['status'] == 'pending').length;
    final rejected = _applications.where((a) => a['status'] == 'rejected').length;

    return RefreshIndicator(
      onRefresh: () async => _load(),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(14, 14, 14, 8),
              child: Row(children: [
                _statChip("Total",    total.toString(),    Colors.blueGrey),
                SizedBox(width: 8),
                _statChip("Pending",  pending.toString(),  Colors.orange),
                SizedBox(width: 8),
                _statChip("Accepted", accepted.toString(), Colors.green),
                SizedBox(width: 8),
                _statChip("Rejected", rejected.toString(), Colors.red),
              ]),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final app    = _applications[index];
                  final status = app['status'] ?? 'pending';
                  final isPending = status == 'pending';

                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: Colors.grey.shade100),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: Offset(0, 2))],
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.all(14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              CircleAvatar(
                                radius: 24,
                                backgroundColor: Color(0xFF021A54).withOpacity(0.1),
                                child: Text(
                                  (app['freelancer_name'] ?? 'F')[0].toUpperCase(),
                                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF021A54)),
                                ),
                              ),
                              SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(app['freelancer_name'] ?? '',
                                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                                    SizedBox(height: 3),
                                    Row(children: [
                                      Icon(Icons.email_outlined, size: 13, color: Colors.grey),
                                      SizedBox(width: 4),
                                      Expanded(child: Text(app['freelancer_email'] ?? '',
                                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                          overflow: TextOverflow.ellipsis)),
                                    ]),
                                    SizedBox(height: 4),
                                    Row(children: [
                                      Icon(Icons.work_outline, size: 13, color: Colors.grey),
                                      SizedBox(width: 4),
                                      Expanded(child: Text(app['job_title'] ?? '',
                                          style: TextStyle(color: Colors.grey[600], fontSize: 12),
                                          overflow: TextOverflow.ellipsis)),
                                    ]),
                                  ],
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _statusColor(status).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: _statusColor(status).withOpacity(0.3)),
                                ),
                                child: Row(mainAxisSize: MainAxisSize.min, children: [
                                  Icon(_statusIcon(status), size: 13, color: _statusColor(status)),
                                  SizedBox(width: 4),
                                  Text(_statusLabel(status),
                                      style: TextStyle(fontSize: 11, color: _statusColor(status), fontWeight: FontWeight.w600)),
                                ]),
                              ),
                            ],
                          ),
                        ),
                        if (isPending) ...[
                          Divider(height: 1, color: Colors.grey.shade100),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton.icon(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.green, foregroundColor: Colors.white,
                                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                    elevation: 0,
                                  ),
                                  icon: Icon(Icons.check, size: 16),
                                  label: Text("Accept", style: TextStyle(fontWeight: FontWeight.w600)),
                                  onPressed: () => _updateStatus(app['id'], 'accepted', index),
                                ),
                                SizedBox(width: 8),
                                OutlinedButton.icon(
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red, side: BorderSide(color: Colors.red.shade300),
                                    padding: EdgeInsets.symmetric(horizontal: 18, vertical: 8),
                                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                                  ),
                                  icon: Icon(Icons.close, size: 16),
                                  label: Text("Reject", style: TextStyle(fontWeight: FontWeight.w600)),
                                  onPressed: () => _updateStatus(app['id'], 'rejected', index),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  );
                },
                childCount: _applications.length,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statChip(String label, String count, Color color) {
    return Expanded(
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Column(children: [
          Text(count, style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: color)),
          Text(label, style: TextStyle(fontSize: 10, color: color.withOpacity(0.8))),
        ]),
      ),
    );
  }
}

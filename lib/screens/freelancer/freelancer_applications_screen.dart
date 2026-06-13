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
  List<dynamic> _applications = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    final auth = context.read<AuthProvider>();
    final data = await ApplicationService(ApiClient(auth)).fetchMyApplications();
    setState(() { _applications = data; _loading = false; });
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

  @override
  Widget build(BuildContext context) {
    if (_loading) return Center(child: CircularProgressIndicator(color: Color(0xFF021A54)));

    if (_applications.isEmpty) return Center(
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        Container(
          padding: EdgeInsets.all(24),
          decoration: BoxDecoration(color: Color(0xFF021A54).withOpacity(0.06), shape: BoxShape.circle),
          child: Icon(Icons.list_alt_outlined, size: 52, color: Color(0xFF021A54).withOpacity(0.4)),
        ),
        SizedBox(height: 16),
        Text("No Applications Yet", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black54)),
        SizedBox(height: 6),
        Text("Browse available jobs and\napply to get started.",
            textAlign: TextAlign.center, style: TextStyle(color: Colors.grey, fontSize: 13)),
      ]),
    );

    final accepted = _applications.where((a) => a['status'] == 'accepted').length;
    final pending  = _applications.where((a) => a['status'] == 'pending').length;

    return RefreshIndicator(
      onRefresh: () async => _load(),
      child: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.fromLTRB(14, 14, 14, 8),
              child: Row(children: [
                _statChip("Total",    _applications.length.toString(), Colors.blueGrey),
                SizedBox(width: 8),
                _statChip("Pending",  pending.toString(),              Colors.orange),
                SizedBox(width: 8),
                _statChip("Accepted", accepted.toString(),             Colors.green),
              ]),
            ),
          ),
          SliverPadding(
            padding: EdgeInsets.fromLTRB(14, 4, 14, 14),
            sliver: SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  final app    = _applications[index];
                  final status = app['status'] ?? 'pending';

                  return Container(
                    margin: EdgeInsets.only(bottom: 12),
                    decoration: BoxDecoration(
                      color: Colors.white, borderRadius: BorderRadius.circular(14),
                      border: Border.all(color: _statusColor(status).withOpacity(0.2)),
                      boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: Offset(0, 2))],
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Container(
                            padding: EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              color: _statusColor(status).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Icon(_statusIcon(status), color: _statusColor(status), size: 22),
                          ),
                          SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(app['job_title'] ?? '',
                                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: Color(0xFF021A54))),
                                SizedBox(height: 4),
                                Text("Rs. ${app['budget']}",
                                    style: TextStyle(color: Colors.green, fontWeight: FontWeight.w600, fontSize: 13)),
                                SizedBox(height: 2),
                                Text("By ${app['posted_by']}", style: TextStyle(color: Colors.grey, fontSize: 12)),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Container(
                                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: _statusColor(status).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(color: _statusColor(status).withOpacity(0.3)),
                                ),
                                child: Text(
                                  status[0].toUpperCase() + status.substring(1),
                                  style: TextStyle(fontSize: 11, color: _statusColor(status), fontWeight: FontWeight.w600),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
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
          Text(label,  style: TextStyle(fontSize: 10, color: color.withOpacity(0.8))),
        ]),
      ),
    );
  }
}

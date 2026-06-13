import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/job_model.dart';
import '../../provider/auth_provider.dart';
import '../../services/api_client.dart';
import '../../services/application_service.dart';

class JobDetailScreen extends StatefulWidget {
  final JobModel job;
  final String role;

  JobDetailScreen({required this.job, required this.role});

  @override
  _JobDetailScreenState createState() => _JobDetailScreenState();
}

class _JobDetailScreenState extends State<JobDetailScreen> {
  bool _applying      = false;
  bool _alreadyApplied = false;

  void _applyJob() async {
    setState(() => _applying = true);
    final auth    = context.read<AuthProvider>();
    final result  = await ApplicationService(ApiClient(auth)).applyJob(widget.job.id!);
    setState(() => _applying = false);

    if (result['success']) {
      setState(() => _alreadyApplied = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Application submitted. Waiting for client review."), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? "Something went wrong."), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Job Detail"),
        backgroundColor: Color(0xFF021A54),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(widget.job.title,
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF021A54))),
            SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.business_outlined, size: 16, color: Colors.grey),
                SizedBox(width: 5),
                Text("Posted by: ${widget.job.postedBy}", style: TextStyle(color: Colors.grey, fontSize: 13)),
              ],
            ),
            SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFF021A54).withOpacity(0.06),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xFF021A54).withOpacity(0.2)),
              ),
              child: Row(
                children: [
                  Icon(Icons.payments_outlined, color: Color(0xFF021A54), size: 22),
                  SizedBox(width: 10),
                  Text("Rs. ${widget.job.budget}",
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF021A54))),
                ],
              ),
            ),
            SizedBox(height: 24),
            Text("Description", style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(widget.job.description,
                style: TextStyle(fontSize: 14, color: Colors.black87, height: 1.6)),
            SizedBox(height: 40),
            if (widget.role == "freelancer")
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                    backgroundColor: _alreadyApplied ? Colors.grey[400] : Color(0xFF021A54),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: _applying
                      ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Icon(_alreadyApplied ? Icons.check_circle_outline : Icons.send_outlined),
                  label: Text(
                    _alreadyApplied ? "Applied" : "Apply for this Job",
                    style: TextStyle(fontSize: 15),
                  ),
                  onPressed: (_applying || _alreadyApplied) ? null : _applyJob,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

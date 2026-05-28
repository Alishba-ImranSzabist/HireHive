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
  bool applying = false;
  bool alreadyApplied = false;

  void _applyJob() async {
    setState(() => applying = true);
    final auth = context.read<AuthProvider>();
    final service = ApplicationService(ApiClient(auth));
    final result = await service.applyJob(widget.job.id!);
    setState(() => applying = false);

    if (result['success']) {
      setState(() => alreadyApplied = true);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Application submitted successfully. Waiting for client review."), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? 'Error'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Job Detail")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              widget.job.title,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF021A54)),
            ),
            SizedBox(height: 10),

            Row(
              children: [
                Icon(Icons.business, size: 16, color: Colors.grey),
                SizedBox(width: 5),
                Text("Posted by: ${widget.job.postedBy}", style: TextStyle(color: Colors.grey)),
              ],
            ),
            SizedBox(height: 15),

            Container(
              width: double.infinity,
              padding: EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Color(0xFF021A54).withOpacity(0.08),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Color(0xFF021A54).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.monetization_on, color: Color(0xFF021A54)),
                  SizedBox(width: 10),
                  Text(
                    "Budget: Rs. ${widget.job.budget}",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF021A54)),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            Text("Description", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(widget.job.description, style: TextStyle(fontSize: 15, color: Colors.black87, height: 1.5)),
            SizedBox(height: 40),

            // Freelancer → Apply button
            if (widget.role == "freelancer")
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: alreadyApplied ? Colors.grey : Color(0xFF021A54),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  icon: applying
                      ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                      : Icon(alreadyApplied ? Icons.check : Icons.send),
                  label: Text(
                    alreadyApplied ? "Applied!" : "Apply for this Job",
                    style: TextStyle(fontSize: 15),
                  ),
                  onPressed: (applying || alreadyApplied) ? null : _applyJob,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

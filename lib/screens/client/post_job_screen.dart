import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/job_model.dart';
import '../../provider/auth_provider.dart';
import '../../services/api_client.dart';
import '../../services/job_service.dart';

class PostJobScreen extends StatefulWidget {
  @override
  _PostJobScreenState createState() => _PostJobScreenState();
}

class _PostJobScreenState extends State<PostJobScreen> {
  final _titleController  = TextEditingController();
  final _budgetController = TextEditingController();
  final _descController   = TextEditingController();
  bool _loading = false;

  void _postJob() async {
    if (_titleController.text.trim().isEmpty || _budgetController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Title and budget are required."), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _loading = true);
    final auth = context.read<AuthProvider>();
    final job = JobModel(
      title:       _titleController.text.trim(),
      budget:      _budgetController.text.trim(),
      description: _descController.text.trim().isEmpty ? "No description provided." : _descController.text.trim(),
      postedBy:    auth.name ?? "Client",
    );
    final success = await JobService(ApiClient(auth)).addJob(job);
    setState(() => _loading = false);

    if (success) {
      _titleController.clear();
      _budgetController.clear();
      _descController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Job posted successfully!"), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to post job. Please try again."), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 10),
          Text("Post a New Job", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF021A54))),
          SizedBox(height: 4),
          Text("Fill in the details below", style: TextStyle(color: Colors.grey[500], fontSize: 13)),
          SizedBox(height: 28),
          TextField(
            controller: _titleController,
            decoration: InputDecoration(
              labelText: "Job Title",
              hintText: "e.g. Flutter App Developer",
              prefixIcon: Icon(Icons.work_outline),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 14),
          TextField(
            controller: _budgetController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: "Budget (Rs.)",
              hintText: "e.g. 50000",
              prefixIcon: Icon(Icons.payments_outlined),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 14),
          TextField(
            controller: _descController,
            maxLines: 4,
            decoration: InputDecoration(
              labelText: "Job Description",
              hintText: "Describe what you need...",
              prefixIcon: Icon(Icons.description_outlined),
              alignLabelWithHint: true,
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            ),
          ),
          SizedBox(height: 32),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF021A54),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(vertical: 15),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              icon: _loading
                  ? SizedBox(width: 18, height: 18, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                  : Icon(Icons.send_outlined),
              label: Text("Post Job", style: TextStyle(fontSize: 16)),
              onPressed: _loading ? null : _postJob,
            ),
          ),
        ],
      ),
    );
  }
}

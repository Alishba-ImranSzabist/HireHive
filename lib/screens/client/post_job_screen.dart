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
  final titleController = TextEditingController();
  final budgetController = TextEditingController();
  final descController = TextEditingController();
  bool loading = false;

  void postJob() async {
    if (titleController.text.isEmpty || budgetController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Title and budget are required."), backgroundColor: Colors.red),
      );
      return;
    }
    setState(() => loading = true);
    final auth = context.read<AuthProvider>();
    final job = JobModel(
      title: titleController.text,
      budget: budgetController.text,
      description: descController.text.isEmpty ? "No description" : descController.text,
      postedBy: auth.name ?? "Client",
    );
    final success = await JobService(ApiClient(auth)).addJob(job);
    setState(() => loading = false);

    if (success) {
      titleController.clear();
      budgetController.clear();
      descController.clear();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Job posted Successfully!"), backgroundColor: Colors.green),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Job posting failed. Please try again."), backgroundColor: Colors.red),
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
          SizedBox(height: 5),
          Text("Fill the details below to post your job", style: TextStyle(color: Colors.grey)),
          SizedBox(height: 25),
          TextField(
            controller: titleController,
            decoration: InputDecoration(labelText: "Job Title", hintText: "e.g. Flutter App Developer", prefixIcon: Icon(Icons.work), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
          ),
          SizedBox(height: 15),
          TextField(
            controller: budgetController,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(labelText: "Budget (Rs.)", hintText: "e.g. 50000", prefixIcon: Icon(Icons.monetization_on), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
          ),
          SizedBox(height: 15),
          TextField(
            controller: descController,
            maxLines: 4,
            decoration: InputDecoration(labelText: "Job Description", hintText: "Describe what you need...", prefixIcon: Icon(Icons.description), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
          ),
          SizedBox(height: 30),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
              icon: loading ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)) : Icon(Icons.send),
              label: Text("Post Job", style: TextStyle(fontSize: 16)),
              onPressed: loading ? null : postJob,
            ),
          ),
        ],
      ),
    );
  }
}

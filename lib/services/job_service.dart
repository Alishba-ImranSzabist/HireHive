import 'dart:convert';
import '../models/job_model.dart';
import 'api_client.dart';

class JobService {
  final ApiClient api;
  JobService(this.api);

  Future<List<JobModel>> fetchJobs() async {
    final res = await api.get("/jobs");
    if (res.statusCode == 200) {
      final List data = jsonDecode(res.body);
      return data.map((e) => JobModel.fromJson(e)).toList();
    }
    throw Exception("Jobs load failed");
  }

  Future<bool> addJob(JobModel job) async {
    final res = await api.post("/jobs", job.toJson());
    return res.statusCode == 200 || res.statusCode == 201;
  }

  Future<bool> updateJob(int id, JobModel job) async {
    final res = await api.put("/jobs/$id", job.toJson());
    return res.statusCode == 200;
  }

  Future<bool> deleteJob(int id) async {
    final res = await api.delete("/jobs/$id");
    return res.statusCode == 200;
  }
}

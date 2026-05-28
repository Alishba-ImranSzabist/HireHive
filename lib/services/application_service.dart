import 'dart:convert';
import 'api_client.dart';

class ApplicationService {
  final ApiClient client;
  ApplicationService(this.client);

  // Freelancer: Apply karo
  Future<Map<String, dynamic>> applyJob(int jobId) async {
    try {
      final res = await client.post('/applications', {'job_id': jobId});
      final data = jsonDecode(res.body);
      if (res.statusCode == 201) return {'success': true};
      return {'success': false, 'message': data['message'] ?? 'Application not submitted'};
    } catch (e) {
      return {'success': false, 'message': 'Could not reach the server.'};
    }
  }

  // Freelancer: Meri applications
  Future<List<dynamic>> fetchMyApplications() async {
    try {
      final res = await client.get('/applications/my');
      if (res.statusCode == 200) return jsonDecode(res.body);
      return [];
    } catch (e) {
      return [];
    }
  }

  // Client: Apni jobs ki applications
  Future<List<dynamic>> fetchClientApplications() async {
    try {
      final res = await client.get('/applications/client');
      if (res.statusCode == 200) return jsonDecode(res.body);
      return [];
    } catch (e) {
      return [];
    }
  }

  // Client: Accept / Reject
  Future<bool> updateStatus(int applicationId, String status) async {
    try {
      final res = await client.put('/applications/$applicationId', {'status': status});
      return res.statusCode == 200;
    } catch (e) {
      return false;
    }
  }
}

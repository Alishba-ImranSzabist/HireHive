import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import '../../services/auth_service.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  String selectedRole = "freelancer";
  bool loading = false;

  void register() async {
    if (nameController.text.isEmpty || emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Fill out the all fields!"), backgroundColor: Colors.red),
      );
      return;
    }
    setState(() => loading = true);
    final authProvider = context.read<AuthProvider>();
    final result = await AuthService(authProvider).register(
      nameController.text.trim(),
      emailController.text.trim(),
      passwordController.text,
      selectedRole,
    );
    setState(() => loading = false);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account created successfully! Please login to continue."), backgroundColor: Colors.green),
      );
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? "Register failed"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Create Account")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text("Join HireHive", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF021A54))),
            SizedBox(height: 5),
            Text("Create your account to get started", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 30),
            TextField(
              controller: nameController,
              decoration: InputDecoration(labelText: "Full Name", prefixIcon: Icon(Icons.person), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(height: 15),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(labelText: "Email", prefixIcon: Icon(Icons.email), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(height: 15),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(labelText: "Password", prefixIcon: Icon(Icons.lock), border: OutlineInputBorder(borderRadius: BorderRadius.circular(10))),
            ),
            SizedBox(height: 20),
            Text("I am a:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedRole = "freelancer"),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: selectedRole == "freelancer" ? Color(0xFF021A54) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0xFF021A54)),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.work, color: selectedRole == "freelancer" ? Colors.white : Color(0xFF021A54)),
                          SizedBox(height: 5),
                          Text("Freelancer", style: TextStyle(color: selectedRole == "freelancer" ? Colors.white : Color(0xFF021A54), fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedRole = "client"),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      decoration: BoxDecoration(
                        color: selectedRole == "client" ? Color(0xFF021A54) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0xFF021A54)),
                      ),
                      child: Column(
                        children: [
                          Icon(Icons.business, color: selectedRole == "client" ? Colors.white : Color(0xFF021A54)),
                          SizedBox(height: 5),
                          Text("Client", style: TextStyle(color: selectedRole == "client" ? Colors.white : Color(0xFF021A54), fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(padding: EdgeInsets.symmetric(vertical: 14), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))),
                onPressed: loading ? null : register,
                child: loading ? CircularProgressIndicator(color: Colors.white) : Text("Sign Up", style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(height: 15),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Already have an account? Login"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

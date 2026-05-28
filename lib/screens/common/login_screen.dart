import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import '../../services/auth_service.dart';
import '../freelancer/freelancer_home.dart';
import '../client/client_home.dart';
import 'signup_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  bool loading = false;

  void login() async {
    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(" Fill out the both Fields Email aur password !"), backgroundColor: Colors.red),
      );
      return;
    }
    setState(() => loading = true);
    final authProvider = context.read<AuthProvider>();
    final result = await AuthService(authProvider).login(
      emailController.text.trim(),
      passwordController.text,
    );
    setState(() => loading = false);

    if (result['success']) {
      final role = result['role'];
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => role == 'client' ? ClientHome() : FreelancerHome()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? "Login failed"), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 10),
            Text("Welcome Back!", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Color(0xFF021A54))),
            SizedBox(height: 5),
            Text("Login to continue", style: TextStyle(color: Colors.grey)),
            SizedBox(height: 30),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 15),
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: loading ? null : login,
                child: loading
                    ? CircularProgressIndicator(color: Colors.white)
                    : Text("Login", style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(height: 15),
            Center(
              child: TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SignupScreen())),
                child: Text("Don't have an account? Sign Up"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

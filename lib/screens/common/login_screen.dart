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
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading     = false;
  bool _obscurePass = true;

  void _login() async {
    final email    = _emailController.text.trim();
    final password = _passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields."), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _loading = true);
    final result = await AuthService(context.read<AuthProvider>()).login(email, password);
    setState(() => _loading = false);

    if (result['success']) {
      final role = result['role'];
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => role == 'client' ? ClientHome() : FreelancerHome()),
        (route) => false,
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? "Login failed."), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: IconThemeData(color: Color(0xFF021A54)),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 16),
            Text("Welcome Back", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF021A54))),
            SizedBox(height: 6),
            Text("Sign in to continue", style: TextStyle(color: Colors.grey[500], fontSize: 14)),
            SizedBox(height: 40),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 16),
            TextField(
              controller: _passwordController,
              obscureText: _obscurePass,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock_outline),
                suffixIcon: IconButton(
                  icon: Icon(_obscurePass ? Icons.visibility_off_outlined : Icons.visibility_outlined),
                  onPressed: () => setState(() => _obscurePass = !_obscurePass),
                ),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF021A54),
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: _loading ? null : _login,
                child: _loading
                    ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text("Login", style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: TextButton(
                onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (_) => SignupScreen())),
                child: Text("Don't have an account? Sign Up", style: TextStyle(color: Color(0xFF021A54))),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

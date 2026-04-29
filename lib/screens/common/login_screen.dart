

// Email + Password → Role check → HomeScreen

import 'package:flutter/material.dart';
import '../../models/user_model.dart';
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

  // Dummy login — role choose
  String selectedRole = "freelancer";

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

            // Email
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

            // Password
            TextField(
              controller: passwordController,
              obscureText: true,
              decoration: InputDecoration(
                labelText: "Password",
                prefixIcon: Icon(Icons.lock),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 20),

            // Role select  for login
            Text("Login as:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedRole = "freelancer"),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedRole == "freelancer" ? Color(0xFF021A54) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0xFF021A54)),
                      ),
                      child: Center(
                        child: Text("Freelancer", style: TextStyle(
                          color: selectedRole == "freelancer" ? Colors.white : Color(0xFF021A54),
                          fontWeight: FontWeight.bold,
                        )),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => selectedRole = "client"),
                    child: Container(
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: selectedRole == "client" ? Color(0xFF021A54) : Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(color: Color(0xFF021A54)),
                      ),
                      child: Center(
                        child: Text("Client", style: TextStyle(
                          color: selectedRole == "client" ? Colors.white : Color(0xFF021A54),
                          fontWeight: FontWeight.bold,
                        )),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            // Login Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  // Save role to global user
                  currentUser.role = selectedRole;
                  currentUser.email = emailController.text;

                  // Role  base navigate
                  if (selectedRole == "freelancer") {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => FreelancerHome()),
                    );
                  } else {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (_) => ClientHome()),
                    );
                  }
                },
                child: Text("Login", style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(height: 15),

            Center(
              child: TextButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => SignupScreen()),
                  );
                },
                child: Text("Don't have an account? Sign Up"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

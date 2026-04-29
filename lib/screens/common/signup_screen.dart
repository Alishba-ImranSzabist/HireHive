

// Name, Email, Password + Role dropdown
//  from Constructor  data pass → ProfileSetup

import 'package:flutter/material.dart';
import '../../models/user_model.dart';
import 'profile_setup_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Role selection
  String selectedRole = "freelancer";

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

            // Name Field
            TextField(
              controller: nameController,
              decoration: InputDecoration(
                labelText: "Full Name",
                prefixIcon: Icon(Icons.person),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 15),

            // Email Field
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

            // Password Field
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

            // Role Selection — simple aur clear
            Text("I am a:", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),

            Row(
              children: [
                // Freelancer option
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
                          Text("Freelancer", style: TextStyle(
                            color: selectedRole == "freelancer" ? Colors.white : Color(0xFF021A54),
                            fontWeight: FontWeight.bold,
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 15),

                // Client option
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
                          Text("Client", style: TextStyle(
                            color: selectedRole == "client" ? Colors.white : Color(0xFF021A54),
                            fontWeight: FontWeight.bold,
                          )),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 30),

            // Signup Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                ),
                onPressed: () {
                  // Save to global user
                  currentUser.name = nameController.text;
                  currentUser.email = emailController.text;
                  currentUser.role = selectedRole;

                  // Constructor se data pass
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (_) => ProfileSetupScreen(role: selectedRole),
                    ),
                  );
                },
                child: Text("Sign Up", style: TextStyle(fontSize: 16)),
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

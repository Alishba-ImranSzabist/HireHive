import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../provider/auth_provider.dart';
import '../../services/auth_service.dart';
import 'login_screen.dart';

class SignupScreen extends StatefulWidget {
  @override
  _SignupScreenState createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  final _nameController     = TextEditingController();
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();
  String _selectedRole = "freelancer";
  bool _loading     = false;
  bool _obscurePass = true;

  void _register() async {
    final name     = _nameController.text.trim();
    final email    = _emailController.text.trim();
    final password = _passwordController.text;

    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Please fill in all fields."), backgroundColor: Colors.red),
      );
      return;
    }

    setState(() => _loading = true);
    final result = await AuthService(context.read<AuthProvider>()).register(name, email, password, _selectedRole);
    setState(() => _loading = false);

    if (result['success']) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Account created! Please log in."), backgroundColor: Colors.green),
      );
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(result['message'] ?? "Registration failed."), backgroundColor: Colors.red),
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
            Text("Create Account", style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Color(0xFF021A54))),
            SizedBox(height: 6),
            Text("Join HireHive today", style: TextStyle(color: Colors.grey[500], fontSize: 14)),
            SizedBox(height: 36),
            TextField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: "Full Name",
                prefixIcon: Icon(Icons.person_outline),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 14),
            TextField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: InputDecoration(
                labelText: "Email",
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            SizedBox(height: 14),
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
            SizedBox(height: 24),
            Text("I am a:", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: Colors.black87)),
            SizedBox(height: 12),
            Row(
              children: [
                Expanded(child: _roleCard("freelancer", "Freelancer", Icons.work_outline)),
                SizedBox(width: 12),
                Expanded(child: _roleCard("client", "Client", Icons.business_center_outlined)),
              ],
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
                onPressed: _loading ? null : _register,
                child: _loading
                    ? SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                    : Text("Sign Up", style: TextStyle(fontSize: 16)),
              ),
            ),
            SizedBox(height: 14),
            Center(
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text("Already have an account? Login", style: TextStyle(color: Color(0xFF021A54))),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _roleCard(String role, String label, IconData icon) {
    final selected = _selectedRole == role;
    return GestureDetector(
      onTap: () => setState(() => _selectedRole = role),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: selected ? Color(0xFF021A54) : Colors.grey[100],
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: selected ? Color(0xFF021A54) : Colors.grey[300]!),
        ),
        child: Column(
          children: [
            Icon(icon, color: selected ? Colors.white : Colors.grey[600], size: 26),
            SizedBox(height: 6),
            Text(label, style: TextStyle(color: selected ? Colors.white : Colors.grey[700], fontWeight: FontWeight.w600)),
          ],
        ),
      ),
    );
  }
}

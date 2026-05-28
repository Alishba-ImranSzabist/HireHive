import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'provider/auth_provider.dart';
import 'screens/common/welcome_screen.dart';
import 'screens/common/login_screen.dart';
import 'screens/common/signup_screen.dart';
import 'screens/freelancer/freelancer_home.dart';
import 'screens/client/client_home.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final authProvider = AuthProvider();
  await authProvider.loadToken();
  runApp(
    ChangeNotifierProvider.value(
      value: authProvider,
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthProvider>(context, listen: false);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'HireHive',
      theme: ThemeData(
        primaryColor: Color(0xFF021A54),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF021A54),
          foregroundColor: Colors.white,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF021A54),
            foregroundColor: Colors.white,
          ),
        ),
      ),
      home: auth.isLoggedIn
          ? (auth.role == 'client' ? ClientHome() : FreelancerHome())
          : WelcomeScreen(),
      routes: {
        '/login': (_) => LoginScreen(),
        '/register': (_) => SignupScreen(),
        '/freelancer': (_) => FreelancerHome(),
        '/client': (_) => ClientHome(),
      },
    );
  }
}

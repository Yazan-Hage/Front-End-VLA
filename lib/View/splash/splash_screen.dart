import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/name_of_pages.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Delay for 3 seconds, then run auth check
    Future.delayed(const Duration(seconds: 3), _checkAuth);
  }

  Future<void> _checkAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('auth_token');
    final next = (token != null && token.isNotEmpty)
        ? Screens.homeScreen
        : Screens.logInScreen;

    if (!mounted) return;
    Navigator.of(context).pushReplacementNamed(next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFF001F3F),
              Color(0xFF003366),
              Color(0xFF004080),
              Color(0xFF005599),
              Color(0xFF0066CC),
              Color(0xFF3385FF),
              Color(0xFF66A3FF),
              Color(0xFF99C2FF),
            ],
          ),
        ),
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Icon(Icons.directions_car_filled, size: 100, color: Colors.white),
              SizedBox(height: 20),
              Text(
                'تطبيق رخص القيادة',
                style: TextStyle(color: Colors.white, fontSize: 28),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }
}

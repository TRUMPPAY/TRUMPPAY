import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(const TrumpPayInvestApp());
}

class TrumpPayInvestApp extends StatelessWidget {
  const TrumpPayInvestApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trump Pay Invest',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.amber,
        scaffoldBackgroundColor: Colors.black,
      ),
      home: const SplashScreen(), // پہلی اسکرین لوڈنگ والی
    );
  }
}

// 1. لوڈنگ اسکرین (Splash Screen) - 3-4 سیکنڈ
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 4), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const WelcomePage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.network('https://drive.google.com/file/d/1JYp66DMxpW2mgpOVvyF_2rpX9ydzdcRg/view?usp=sharing', height: 200),
            const SizedBox(height: 20),
            const CircularProgressIndicator(color: Colors.amber),
          ],
        ),
      ),
    );
  }
}

// 2. ویلکم پیج (Welcome Page) - 6 سیکنڈ بعد خودکار منتقلی
class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  void initState() {
    super.initState();
    Timer(const Duration(seconds: 6), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Center(child: Image.network('https://drive.google.com/file/d/1JYp66DMxpW2mgpOVvyF_2rpX9ydzdcRg/view?usp=sharing')),
          Positioned(
            bottom: 50,
            left: 20,
            right: 20,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, padding: const EdgeInsets.symmetric(vertical: 15)),
              onPressed: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const AuthScreen()));
              },
              child: const Text('Get Started', style: TextStyle(color: Colors.black, fontSize: 18, fontWeight: FontWeight.bold)),
            ),
          ),
        ],
      ),
    );
  }
}

// 3. رجسٹریشن اور لاگ ان اسکرین
class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = false;
  bool showPassword = false;
  int otpTimer = 120; // 2 منٹ (120 سیکنڈ)
  Timer? timer;

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      setState(() {
        if (otpTimer > 0) otpTimer--;
        else timer?.cancel();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      app_bar: AppBar(
        title: Text(isLogin ? "Login" : "Register", style: const TextStyle(color: Colors.amber)),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextButton(onPressed: () => setState(() => isLogin = true), child: Text("Login", style: TextStyle(color: isLogin ? Colors.amber : Colors.grey))),
                TextButton(onPressed: () => setState(() => isLogin = false), child: Text("Register", style: TextStyle(color: !isLogin ? Colors.amber : Colors.grey))),
              ],
            ),
            const SizedBox(height: 20),
            if (!isLogin) ...[
              // رجسٹریشن فارم
              TextField(decoration: const InputDecoration(labelText: 'Full Name (3-15 chars)', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              // کنٹری سلیکٹر (یہاں اے پی آئی لاجک لگے گی)
              DropdownButtonFormField(items: const [DropdownMenuItem(child: Text("Pakistan +92"))], onChanged: (val){}, decoration: const InputDecoration(labelText: 'Select Country', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              TextField(decoration: const InputDecoration(labelText: 'Mobile Number', border: OutlineInputBorder())),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(child: TextField(decoration: const InputDecoration(labelText: '6-digit OTP', border: OutlineInputBorder()))),
                  TextButton(onPressed: startTimer, child: Text(otpTimer == 120 ? "Get OTP" : "$otpTimer s")),
                ],
              ),
            ],
            if (isLogin) ...[
               TextField(decoration: const InputDecoration(labelText: 'Mobile Number', border: OutlineInputBorder())),
               const SizedBox(height: 10),
            ],
            TextField(
              obscureText: !showPassword,
              decoration: InputDecoration(
                labelText: 'Password (6-9 chars)',
                border: const OutlineInputBorder(),
                suffixIcon: IconButton(icon: Icon(showPassword ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => showPassword = !showPassword)),
              ),
            ),
            if (isLogin) Align(alignment: Alignment.centerRight, child: TextButton(onPressed: () {}, child: const Text("Forgot Password?"))),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, minimumSize: const Size(double.infinity, 50)),
              onPressed: () {}, 
              child: Text(isLogin ? "Login Now" : "Register Now", style: const TextStyle(color: Colors.black)),
            ),
          ],
        ),
      ),
    );
  }
}


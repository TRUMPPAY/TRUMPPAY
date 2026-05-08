import 'package:flutter/material.dart';
import 'dart:async';

void main() {
  runApp(TrumpPayFarmApp());
}

class TrumpPayFarmApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Trump Pay Farm',
      theme: ThemeData(primarySwatch: Colors.amber),
      home: SplashScreen(), // سب سے پہلے لوڈنگ اسکرین
    );
  }
}

// 1. لوڈنگ اسکرین (Splash Screen) - 3 سے 4 سیکنڈ
class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 4), () {
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => WelcomeScreen()));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://drive.google.com/thumbnail?id=1JYp66DMxpW2mgpOVvyF_2rpX9ydzdcRg&sz=w1000'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(child: CircularProgressIndicator(color: Colors.golden)),
      ),
    );
  }
}

// 2. ویلکم پیج (Welcome Page) - 6 سیکنڈ آٹو یا کلک
class WelcomeScreen extends StatefulWidget {
  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(Duration(seconds: 6), _nextScreen);
  }

  void _nextScreen() {
    _timer?.cancel();
    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AuthScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.network(
            'https://drive.google.com/thumbnail?id=1JYp66DMxpW2mgpOVvyF_2rpX9ydzdcRg&sz=w1000',
            fit: BoxFit.cover, width: double.infinity, height: double.infinity,
          ),
          Positioned(
            bottom: 50,
            left: 20, right: 20,
            child: ElevatedButton(
              onPressed: _nextScreen,
              child: Text("GET STARTED", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, padding: EdgeInsets.symmetric(vertical: 15)),
            ),
          )
        ],
      ),
    );
  }
}

// 3. آتھنٹیکیشن اسکرین (Register/Login Toggle)
class AuthScreen extends StatefulWidget {
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  bool isLogin = false; // لاگ ان یا رجسٹر سوئچ
  final _formKey = GlobalKey<FormState>();
  
  // فیلڈ کنٹرولرز
  TextEditingController nameController = TextEditingController();
  TextEditingController phoneController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  TextEditingController passController = TextEditingController();
  
  bool _showPass = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(isLogin 
                ? 'https://drive.google.com/thumbnail?id=1zvj7wF6xYceOpIJNlUZB0XAQT6rV_Cyb&sz=w1000'
                : 'https://drive.google.com/thumbnail?id=175cXjtxZutKWg6VgN6cWo11Ddu4Z4ZbJ&sz=w1000'),
              fit: BoxFit.cover,
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(25.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // لاگ ان / رجسٹر بٹن اوپر
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      TextButton(onPressed: () => setState(() => isLogin = true), child: Text("LOGIN", style: TextStyle(color: isLogin ? Colors.amber : Colors.white))),
                      TextButton(onPressed: () => setState(() => isLogin = false), child: Text("REGISTER", style: TextStyle(color: !isLogin ? Colors.amber : Colors.white))),
                    ],
                  ),
                  
                  if (!isLogin) ...[
                    // فل نیم فیلڈ (3 سے 15 حروف)
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(hintText: "Full Name", fillColor: Colors.white.withOpacity(0.8), filled: true),
                      validator: (val) => (val!.length < 3 || val.length > 15) ? "Name 3-15 characters only" : null,
                    ),
                    SizedBox(height: 10),
                  ],

                  // کنٹری کوڈ اور فون (238 ممالک کی لسٹ یہاں اے پی آئی سے جڑے گی)
                  Row(
                    children: [
                      Container(width: 80, child: TextField(decoration: InputDecoration(hintText: "+92", filled: true, fillColor: Colors.white))),
                      Expanded(child: TextField(controller: phoneController, decoration: InputDecoration(hintText: "Phone Number", filled: true, fillColor: Colors.white))),
                    ],
                  ),
                  SizedBox(height: 10),

                  // پاسورڈ فیلڈ (6 سے 9 حروف)
                  TextFormField(
                    controller: passController,
                    obscureText: !_showPass,
                    decoration: InputDecoration(
                      hintText: "Password (6-9 digits)", 
                      fillColor: Colors.white.withOpacity(0.8), filled: true,
                      suffixIcon: IconButton(icon: Icon(_showPass ? Icons.visibility : Icons.visibility_off), onPressed: () => setState(() => _showPass = !_showPass)),
                    ),
                    validator: (val) => (val!.length < 6 || val.length > 9) ? "Password must be 6-9 chars" : null,
                  ),
                  
                  SizedBox(height: 20),
                  
                  ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {
                        // رجسٹر یا لاگ ان لاجک یہاں آئے گی
                        Navigator.push(context, MaterialPageRoute(builder: (context) => HomeScreen()));
                      }
                    },
                    child: Text(isLogin ? "LOGIN NOW" : "REGISTER NOW"),
                    style: ElevatedButton.styleFrom(backgroundColor: Colors.amber, minimumSize: Size(double.infinity, 50)),
                  ),
                  
                  if (isLogin) 
                    TextButton(
                      onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => ForgetPassScreen())),
                      child: Text("Forget Password?", style: TextStyle(color: Colors.white)),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

// 4. ہوم اسکرین (Home Screen)
class HomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://drive.google.com/thumbnail?id=13V2BuxdCsZFIREnhj2uNJkfPKt1h8tXJ&sz=w1000'),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(child: Text("Welcome to Trump Pay Farm", style: TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold))),
      ),
    );
  }
}

// 5. فورگیٹ پاسورڈ اسکرین (Forget Password)
class ForgetPassScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://drive.google.com/thumbnail?id=12TflAIgY3iNvTDVJTv-z31g_IwqNcdJc&sz=w1000'),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(decoration: InputDecoration(hintText: "Enter 6 Digit OTP", filled: true, fillColor: Colors.white)),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => Navigator.push(context, MaterialPageRoute(builder: (context) => SetNewPassScreen())),
              child: Text("Verify OTP"),
            )
          ],
        ),
      ),
    );
  }
}

// 6. نیا پاسورڈ سیٹ کریں (Set New Password)
class SetNewPassScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage('https://drive.google.com/thumbnail?id=1FdQalekMLyFT9uzeN6mqj7Kkb3p1QZtT&sz=w1000'),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(30.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(decoration: InputDecoration(hintText: "New Password (6-9)", filled: true, fillColor: Colors.white)),
              SizedBox(height: 10),
              TextField(decoration: InputDecoration(hintText: "Confirm Password", filled: true, fillColor: Colors.white)),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => HomeScreen())),
                child: Text("SET PASSWORD"),
                style: ElevatedButton.styleFrom(backgroundColor: Colors.amber),
              )
            ],
          ),
        ),
      ),
    );
  }
}


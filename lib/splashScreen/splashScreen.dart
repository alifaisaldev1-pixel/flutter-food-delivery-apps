import 'package:flutter/material.dart';
import 'package:food_delivery_app/onboarding_screens/onboarding_Screen.dart';

class splashScreen extends StatefulWidget {
  const splashScreen({super.key});

  @override
  State<splashScreen> createState() => _splashScreenState();
}

class _splashScreenState extends State<splashScreen> {
  @override
  void initState() {
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) =>  OnboardingScreen()),
      );
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
 // double height = MediaQuery.of(context).size.height*0.90;
  //double width = MediaQuery.of(context).size.width*0.60;
    return Scaffold(
      body: Container(
        color: Colors.white,
        child: Center(
          child: Image.asset(
            "assets/images/splash_images/splash_image1.png",
          height: double.infinity,
          width: double.infinity,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}

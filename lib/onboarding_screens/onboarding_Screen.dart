import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/Sign_up/Login/sign_up.dart';
import 'package:food_delivery_app/onboarding_Screens/onboarding_entity.dart';
import 'package:food_delivery_app/widgets/custom_button.dart';

class OnboardingScreen extends StatefulWidget {
  OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final List<onboardingEntity> onboardingData = onboarding_data;
  final PageController _pageController = PageController();
  int currentIndex = 0;
  FirebaseAuth  auth = FirebaseAuth.instance;
  User? user  = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.40;
    double width = MediaQuery.of(context).size.width * 0.80;
    return PageView.builder(
      onPageChanged: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      controller: _pageController,
      itemCount: onboarding_data.length,
      itemBuilder: (context, index) {
        index = index % onboarding_data.length; // Ensure index is within bounds
        return Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 16.0,
              horizontal: 16.0,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Image.asset(
                  onboarding_data[index].image,
                  height: height,
                  width: width,
                  fit: BoxFit.contain,
                ),
                Text(
                  onboarding_data[index].title,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 22,
                    color: Colors.black87,
                    decoration: TextDecoration.none,
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  onboarding_data[index].description,
                  textAlign: TextAlign.center,

                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    decoration: TextDecoration.none,
                  ),
                ),
           const     SizedBox(height: 20),
                CustomButton(
                  height:50,
                  color: Colors.blueAccent,
                  text: index == onboarding_data.length - 1
                      ? 'Get Started'
                      : 'Next',
                  onPressed: () {
                    if (mounted) {
                      if (index < onboarding_data.length - 1) {
                        _pageController.nextPage(
                          duration: const Duration(milliseconds: 300),
                          curve: Curves.easeIn,
                        );
                      } else {
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(builder: (context) => const Signup()),
                        );
                      }
                    }
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

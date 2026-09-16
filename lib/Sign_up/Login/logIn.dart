import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/Dashboard/home.dart';
import 'package:food_delivery_app/Sign_up/Login/sign_up.dart';
import 'package:food_delivery_app/Utils/toast_message.dart';
import 'package:food_delivery_app/widgets/custom_button.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? emailError;
  String? passwordError;

  bool _isValidEmail(String email) {
    final trimmedEmail = email.trim();
    if (trimmedEmail.isEmpty || trimmedEmail.contains(' ')) {
      return false;
    }

    final parts = trimmedEmail.split('@');
    if (parts.length != 2) {
      return false;
    }

    final localPart = parts[0];
    final domainPart = parts[1];
    final domainSections = domainPart.split('.');

    return localPart.isNotEmpty &&
        domainPart.isNotEmpty &&
        domainSections.length >= 2 &&
        domainSections.every((section) => section.isNotEmpty);
  }

  Future<void> _login() async {
    setState(() {
      emailError = null;
      passwordError = null;
    });

    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty) {
      setState(() {
        emailError = 'Email is required';
      });
      ToastMessage.showErrorToast('Email is required');
      return;
    }

    if (!_isValidEmail(email)) {
      setState(() {
        emailError = 'Please enter a valid email address';
      });
      ToastMessage.showErrorToast('Please enter a valid email address');
      return;
    }

    if (password.isEmpty) {
      setState(() {
        passwordError = 'Password is required';
      });
      ToastMessage.showErrorToast('Password is required');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      if (!mounted) return;
      ToastMessage.showSuccessToast('Login Successful');
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const Home()),
      );
    } on FirebaseAuthException catch (e) {
      String message = 'Login failed';

      if (e.code == 'user-not-found') {
        message = 'No account found for this email';
      } else if (e.code == 'wrong-password') {
        message = 'Incorrect password';
      } else if (e.code == 'invalid-credential') {
        message = 'Incorrect email or password';
      } else if (e.code == 'invalid-email') {
        message = 'Please check the email address and try again';
      } else if (e.code == 'too-many-requests') {
        message = 'Too many attempts. Please try again later';
      } else if (e.code == 'network-request-failed') {
        message = 'No internet connection. Please try again';
      } else if (e.code == 'user-disabled') {
        message = 'This account has been disabled';
      } else {
        message = e.message ?? message;
      }

      ToastMessage.showErrorToast(message);
    } catch (e) {
      ToastMessage.showErrorToast('Unable to login right now');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _forgotPassword() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      setState(() {
        emailError = 'Email is required';
      });
      ToastMessage.showErrorToast('Enter your email to reset password');
      return;
    }

    if (!_isValidEmail(email)) {
      setState(() {
        emailError = 'Please enter a valid email address';
      });
      ToastMessage.showErrorToast('Please enter a valid email address');
      return;
    }

    try {
      await FirebaseAuth.instance.sendPasswordResetEmail(email: email);
      ToastMessage.showSuccessToast('Password reset link sent to your email');
    } on FirebaseAuthException catch (e) {
      String message = 'Unable to send reset link';
      if (e.code == 'user-not-found') {
        message = 'No account found for this email';
      } else if (e.code == 'invalid-email') {
        message = 'Please check the email address and try again';
      } else if (e.code == 'network-request-failed') {
        message = 'No internet connection. Please try again';
      }
      ToastMessage.showErrorToast(message);
    } catch (e) {
      ToastMessage.showErrorToast('Unable to send reset link');
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height * 0.90;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    height: height,
                    width: double.infinity,
                    color: const Color(0xFF121223),
                    child: Column(
                      children: [
                        SizedBox(height: height * 0.22),
                        const Text(
                          'Login',
                          style: TextStyle(
                            fontSize: 27,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                            decoration: TextDecoration.none,
                          ),
                        ),
                        const Text(
                          'Sign in to continue',
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.white70,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Positioned(
                    bottom: -280,
                    right: 0,
                    left: 0,
                    child: Container(
                      height: height,
                      width: double.infinity,
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30),
                          topRight: Radius.circular(30),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            const Text(
                              'Email',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2A2A3D),
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: emailController,
                              focusNode: emailFocus,
                              keyboardType: TextInputType.emailAddress,
                              textInputAction: TextInputAction.next,
                              onEditingComplete: () {
                                FocusScope.of(context).requestFocus(passwordFocus);
                              },
                              onChanged: (value) {
                                if (emailError != null) {
                                  setState(() {
                                    emailError = null;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFF0F3F8),
                                hintText: 'Enter your email',
                                errorText: emailError,
                                errorStyle: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: emailError != null
                                      ? const BorderSide(color: Colors.red)
                                      : BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: emailError != null
                                      ? const BorderSide(color: Colors.red)
                                      : BorderSide.none,
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                            const Text(
                              'Password',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2A2A3D),
                                decoration: TextDecoration.none,
                              ),
                            ),
                            const SizedBox(height: 10),
                            TextField(
                              controller: passwordController,
                              focusNode: passwordFocus,
                              textInputAction: TextInputAction.done,
                              onEditingComplete: _login,
                              obscureText: _obscurePassword,
                              onChanged: (value) {
                                if (passwordError != null) {
                                  setState(() {
                                    passwordError = null;
                                  });
                                }
                              },
                              decoration: InputDecoration(
                                filled: true,
                                fillColor: const Color(0xFFF0F3F8),
                                hintText: 'Enter your password',
                                errorText: passwordError,
                                errorStyle: const TextStyle(
                                  color: Colors.red,
                                  fontSize: 12,
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: passwordError != null
                                      ? const BorderSide(color: Colors.red)
                                      : BorderSide.none,
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: passwordError != null
                                      ? const BorderSide(color: Colors.red)
                                      : BorderSide.none,
                                ),
                                suffixIcon: IconButton(
                                  icon: Icon(
                                    _obscurePassword
                                        ? Icons.visibility_off
                                        : Icons.visibility,
                                    color: const Color(0xFF2A2A3D),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      _obscurePassword = !_obscurePassword;
                                    });
                                  },
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 14,
                                ),
                              ),
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                onPressed: _forgotPassword,
                                child: const Text(
                                  'Forgot Password?',
                                  style: TextStyle(
                                    color: Colors.orange,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 120),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: CustomButton(
                  height: 60,
                  text: _isLoading ? 'Logging In...' : 'Login',
                  color: Colors.orange,
                  onPressed: _login,
                  isLoading: _isLoading,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('Don\'t have an account?'),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const Signup()),
                      );
                    },
                    child: const Text(
                      'Sign Up',
                      style: TextStyle(color: Colors.orange),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
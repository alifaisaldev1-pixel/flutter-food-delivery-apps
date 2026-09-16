import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:food_delivery_app/Dashboard/home.dart';
import 'package:food_delivery_app/Sign_up/Login/logIn.dart';
import 'package:food_delivery_app/Utils/toast_message.dart';
import 'package:food_delivery_app/widgets/custom_button.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FocusNode nameFocus = FocusNode();
  final FocusNode emailFocus = FocusNode();
  final FocusNode passwordFocus = FocusNode();
  bool _isLoading = false;
  bool _obscurePassword = true;
  String? nameError;
  String? emailError;
  String? passwordError;

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegex.hasMatch(email);
  }

  Future<void> _signUp() async {
    setState(() {
      nameError = null;
      emailError = null;
      passwordError = null;
    });

    if (nameController.text.trim().isEmpty) {
      setState(() {
        nameError = 'Name is required';
      });
      return;
    }

    if (emailController.text.trim().isEmpty) {
      setState(() {
        emailError = 'Email is required';
      });
      return;
    }

    if (!_isValidEmail(emailController.text.trim())) {
      setState(() {
        emailError = 'Invalid email format';
      });
      return;
    }

    if (passwordController.text.trim().length < 8) {
      setState(() {
        passwordError = 'Password must be at least 8 characters';
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userCredential = await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: emailController.text.trim(),
            password: passwordController.text.trim(),
          );

      await userCredential.user?.updateDisplayName(nameController.text.trim());
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({
            'name': nameController.text.trim(),
            'email': emailController.text.trim(),
          });

      ToastMessage.showSuccessToast('Sign up successful!');

      if (mounted) {
        Navigator.of(
          context,
        ).pushReplacement(MaterialPageRoute(builder: (_) => const Home()));
      }

      nameController.clear();
      emailController.clear();
      passwordController.clear();
    } on FirebaseAuthException catch (e) {
      String message = 'Sign up failed';

      if (e.code == 'email-already-in-use') {
        message = 'Email already in use';
      } else if (e.code == 'invalid-email') {
        message = 'Invalid email';
      } else if (e.code == 'weak-password') {
        message = 'Password is too weak';
      } else if (e.code == 'user-disabled') {
        message = 'User account disabled';
      } else if (e.code == 'configuration-not-found') {
        message =
            'Firebase Auth is not enabled for this project. Please enable Email/Password in Firebase Console and add localhost to Authorized domains.';
      } else {
        message = e.message ?? 'Sign up failed: ${e.code}';
      }

      ToastMessage.showErrorToast(message);
    } on FirebaseException catch (e) {
      ToastMessage.showErrorToast('Firebase Error: ${e.message}');
    } catch (e) {
      ToastMessage.showErrorToast('Error: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    nameFocus.dispose();
    emailFocus.dispose();
    passwordFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.90;
    return Scaffold(
      body: SingleChildScrollView(
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
                        "Sign Up",
                        style: TextStyle(
                          fontSize: 27,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                          decoration: TextDecoration.none,
                        ),
                      ),
                      const Text(
                        "Create your account to get started",
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
                            'Name',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF2A2A3D),
                              decoration: TextDecoration.none,
                            ),
                          ),
                          const SizedBox(height: 10),
                          TextField(
                            controller: nameController,
                            focusNode: nameFocus,
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () {
                              FocusScope.of(context).requestFocus(emailFocus);
                            },
                            onChanged: (value) {
                              if (nameError != null) {
                                setState(() {
                                  nameError = null;
                                });
                              }
                            },
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: const Color(0xFFF0F3F8),
                              hintText: 'Enter your name',
                              errorText: nameError,
                              errorStyle: const TextStyle(
                                color: Colors.red,
                                fontSize: 12,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: nameError != null
                                    ? const BorderSide(color: Colors.red)
                                    : BorderSide.none,
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                                borderSide: nameError != null
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
                            textInputAction: TextInputAction.next,
                            onEditingComplete: () {
                              FocusScope.of(
                                context,
                              ).requestFocus(passwordFocus);
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
                          const SizedBox(height: 10),
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
                            onEditingComplete: () {
                              _signUp();
                            },
                            onChanged: (value) {
                              if (passwordError != null) {
                                setState(() {
                                  passwordError = null;
                                });
                              }
                            },
                            obscureText: _obscurePassword,
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
                text: _isLoading ? 'Creating Account...' : 'Sign Up',
                color: Colors.orange,
                onPressed: _signUp,
                isLoading: _isLoading,
              ),
            ),
            const SizedBox(height: 20),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('you have an account?'),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const Login()),
                    );
                  },
                  child: const Text('Login'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

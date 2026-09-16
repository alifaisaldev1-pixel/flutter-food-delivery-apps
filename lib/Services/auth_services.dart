import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:food_delivery_app/Utils/toast_message.dart';

class AuthService {
  static Future<void> registerUser({
    required String name,
    required String email,
    required String password,
  }) async {
    if (name.isEmpty || email.isEmpty || password.isEmpty) {
      ToastMessage.showErrorToast("Please fill all fields");
      return;
    }

    try {
      final userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = userCredential.user;
      if (user == null) {
        ToastMessage.showErrorToast("Sign Up failed. Please try again.");
        return;
      }

      await user.updateDisplayName(name);
      await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
        'name': name,
        'email': email,
        'createdAt': FieldValue.serverTimestamp(),
      });

      ToastMessage.showSuccessToast("Sign Up Successful");
    } on FirebaseAuthException catch (e) {
      String message = "Sign Up Failed";

      if (e.code == 'email-already-in-use') {
        message = "Email already in use";
      } else if (e.code == 'invalid-email') {
        message = "Invalid email";
      } else if (e.code == 'weak-password') {
        message = "Password is too weak";
      }

      ToastMessage.showErrorToast(message);
    } catch (e) {
      ToastMessage.showErrorToast("Unable to save user details. Please try again.");
    }
  }

  static Future<void> loginUser({
    required String email,
    required String password,
  }) async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      ToastMessage.showSuccessToast("Login Successful");
    } on FirebaseAuthException catch (e) {
      String message = "Login Failed";

      if (e.code == 'user-not-found') {
        message = "User not found";
      } else if (e.code == 'wrong-password') {
        message = "Wrong password";
      } else if (e.code == 'invalid-credential') {
        message = "Invalid email or password";
      }

      ToastMessage.showErrorToast(message);
    }
  }
}
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:food_delivery_app/Sign_up/Login/logIn.dart';

void main() {
  testWidgets('login screen shows email, password, and forgot password UI', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: Login()));

    expect(find.text('Login'), findsWidgets);
    expect(find.text('Email'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Forgot Password?'), findsOneWidget);
    expect(find.text('Login'), findsWidgets);
  });
}

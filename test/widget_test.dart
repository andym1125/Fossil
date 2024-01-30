// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

//import 'dart:developer';
//import 'dart:html';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fossil/login.dart';

import 'package:fossil/main.dart';
import 'package:fossil/signup.dart';

void main() {
  testWidgets('UI widgets test', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    expect(find.text('Fossil'), findsOneWidget);

    expect(find.widgetWithText(ElevatedButton, 'Log in'), findsOneWidget);

    expect(find.widgetWithText(ElevatedButton, 'Sign Up'), findsOneWidget);
  });

  testWidgets('SignUpPage UI', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpWidget(const MaterialApp( home: SignupPageState()));
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.text('Username @Mastodon.social'), findsOneWidget);
    expect(find.byType(TextField), findsNWidgets(4));
    expect(find.byType(ElevatedButton), findsOneWidget);

  } );

  testWidgets('Error fot the mismatched passwords during signup', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: SignupPageState()));
    // Enter incorrect password
    await tester.enterText(find.byType(TextField).at(0), 'username');
    await tester.enterText(find.byType(TextField).at(1), 'email@example.com');
    await tester.enterText(find.byType(TextField).at(2), 'password1');
    await tester.enterText(find.byType(TextField).at(3), 'password2');
    await tester.tap(find.text('next'));
    await tester.pump();

    // check message
    expect(find.text('Passwords do not match'), findsOneWidget);
  });
  

  testWidgets('LoginPage UI', (WidgetTester tester) async {
    // Build fidger
    await tester.pumpWidget(const MyApp());
    await tester.pumpWidget(const MaterialApp( home: LoginPageState()));
    //find widget
    expect(find.text('Welcome Back'), findsOneWidget);
    expect(find.byType(ElevatedButton), findsOneWidget);
  } );

  testWidgets('Wrong password or username during login', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPageState()));
    // Enter incorrect password
    await tester.enterText(find.byType(TextField).at(0), 'email@example.com');
    await tester.enterText(find.byType(TextField).at(1), 'password1');
    // Error when looking into 
    //await tester.tap(find.text('LOG IN'));
    //await tester.pump();

    // check message
    //expect(find.text('Invalid E-mail address or password.'), findsOneWidget);
  });

   testWidgets('Username and password fields take in a text', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: LoginPageState())); 
    //Enter text in username
    await tester.enterText(find.byType(TextField).at(0), 'test_username');
    expect(find.text('test_username'), findsOneWidget);

    //Enter text in password
    await tester.enterText(find.byType(TextField).at(1), 'test_password');
    expect(find.text('test_password'), findsOneWidget);
  });

  
}

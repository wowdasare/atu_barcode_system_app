// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';

import 'package:atu_barcode_system/main.dart';
import 'package:atu_barcode_system/providers/auth_provider.dart';
import 'package:atu_barcode_system/providers/course_provider.dart';
import 'package:atu_barcode_system/providers/attendance_provider.dart';

void main() {
  group('ATU Barcode System Tests', () {
    testWidgets('App should start with splash screen', (WidgetTester tester) async {
      // Build our app and trigger a frame.
      await tester.pumpWidget(const MyApp());

      // Verify that our app starts with the splash screen
      expect(find.text('ATU Attendance'), findsOneWidget);
      expect(find.text('Barcode Attendance System'), findsOneWidget);
      
      // Verify loading indicator
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('Should show login screen after splash', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      
      // Wait for splash screen animation and navigation
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // Should navigate to login screen
      expect(find.text('Welcome Back'), findsOneWidget);
      expect(find.text('Sign in to continue'), findsOneWidget);
    });

    testWidgets('Login form validation works', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // Find login button and tap it without entering credentials
      final loginButton = find.text('Sign In');
      expect(loginButton, findsOneWidget);
      
      await tester.tap(loginButton);
      await tester.pump();
      
      // Should show validation errors
      expect(find.text('Please enter your username'), findsOneWidget);
      expect(find.text('Please enter your password'), findsOneWidget);
    });

    testWidgets('Login form accepts valid credentials', (WidgetTester tester) async {
      await tester.pumpWidget(const MyApp());
      await tester.pumpAndSettle(const Duration(seconds: 3));
      
      // Enter valid credentials
      await tester.enterText(find.byType(TextFormField).first, 'testuser');
      await tester.enterText(find.byType(TextFormField).last, 'password123');
      
      // Tap login button
      await tester.tap(find.text('Sign In'));
      await tester.pump();
      
      // Should show loading state
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });
  });

  group('Provider Tests', () {
    late AuthProvider authProvider;
    late CourseProvider courseProvider;
    late AttendanceProvider attendanceProvider;

    setUp(() {
      authProvider = AuthProvider();
      courseProvider = CourseProvider();
      attendanceProvider = AttendanceProvider();
    });

    test('AuthProvider initial state', () {
      expect(authProvider.user, isNull);
      expect(authProvider.isLoading, isFalse);
      expect(authProvider.errorMessage, isNull);
      expect(authProvider.isAuthenticated, isFalse);
    });

    test('CourseProvider initial state', () {
      expect(courseProvider.courses, isEmpty);
      expect(courseProvider.isLoading, isFalse);
      expect(courseProvider.errorMessage, isNull);
    });

    test('AttendanceProvider initial state', () {
      expect(attendanceProvider.currentSession, isNull);
      expect(attendanceProvider.attendanceRecords, isEmpty);
      expect(attendanceProvider.isLoading, isFalse);
      expect(attendanceProvider.isScanning, isFalse);
      expect(attendanceProvider.errorMessage, isNull);
    });
  });
}

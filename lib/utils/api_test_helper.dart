import 'package:dio/dio.dart';
import '../constants/api_constants.dart';
import '../services/api_service.dart';

class ApiTestHelper {
  static final ApiTestHelper _instance = ApiTestHelper._internal();
  factory ApiTestHelper() => _instance;
  ApiTestHelper._internal();

  final Dio _dio = Dio();
  final ApiService _apiService = ApiService();

  Future<void> testAllEndpoints({
    String testUsername = 'test_lecturer',
    String testPassword = 'test_password',
  }) async {
    print('🔍 Starting comprehensive API test...');
    print('Base URL: ${ApiConstants.baseUrl}');
    
    // Test 1: Login
    print('\n📝 Testing Login...');
    try {
      final loginResponse = await _apiService.login(testUsername, testPassword);
      if (loginResponse.success) {
        print('✅ Login successful');
        print('Token: ${loginResponse.data?.substring(0, 20)}...');
      } else {
        print('❌ Login failed: ${loginResponse.message}');
        return; // Can't continue without login
      }
    } catch (e) {
      print('❌ Login error: $e');
      return;
    }

    // Test 2: Get Courses
    print('\n📚 Testing Get Courses...');
    try {
      final coursesResponse = await _apiService.getCourses();
      if (coursesResponse.success && coursesResponse.data != null) {
        print('✅ Courses loaded successfully');
        print('Course count: ${coursesResponse.data!.length}');
        if (coursesResponse.data!.isNotEmpty) {
          final firstCourse = coursesResponse.data!.first;
          print('First course: ${firstCourse.title} (ID: ${firstCourse.id})');
          
          // Test 3: Start Session
          print('\n🎯 Testing Start Session...');
          try {
            final sessionResponse = await _apiService.startSession(
              courseId: firstCourse.id,
              location: 'Test Room 101',
              notes: 'API Test Session',
            );
            
            if (sessionResponse.success && sessionResponse.data != null) {
              print('✅ Session started successfully');
              final session = sessionResponse.data!;
              print('Session ID: ${session.id}');
              print('Session location: ${session.location}');
              
              // Test 4: Record Attendance
              print('\n📝 Testing Record Attendance...');
              try {
                final attendanceResponse = await _apiService.recordAttendance(
                  sessionId: session.id,
                  barcodeData: 'TEST_BARCODE_123',
                );
                
                if (attendanceResponse.success && attendanceResponse.data != null) {
                  print('✅ Attendance recorded successfully');
                  final record = attendanceResponse.data!;
                  print('Student: ${record.studentName}');
                  print('Student Number: ${record.studentNumber}');
                } else {
                  print('❌ Record attendance failed: ${attendanceResponse.message}');
                }
              } catch (e) {
                print('❌ Record attendance error: $e');
              }
              
              // Test 5: Get Session Attendance
              print('\n👥 Testing Get Session Attendance...');
              try {
                final attendanceListResponse = await _apiService.getSessionAttendance(session.id);
                
                if (attendanceListResponse.success && attendanceListResponse.data != null) {
                  print('✅ Session attendance loaded successfully');
                  print('Attendee count: ${attendanceListResponse.data!.length}');
                } else {
                  print('❌ Get session attendance failed: ${attendanceListResponse.message}');
                }
              } catch (e) {
                print('❌ Get session attendance error: $e');
              }
              
              // Test 6: End Session
              print('\n🔚 Testing End Session...');
              try {
                final endSessionResponse = await _apiService.endSession(session.id);
                
                if (endSessionResponse.success) {
                  print('✅ Session ended successfully');
                } else {
                  print('❌ End session failed: ${endSessionResponse.message}');
                }
              } catch (e) {
                print('❌ End session error: $e');
              }
              
            } else {
              print('❌ Start session failed: ${sessionResponse.message}');
            }
          } catch (e) {
            print('❌ Start session error: $e');
          }
        }
      } else {
        print('❌ Get courses failed: ${coursesResponse.message}');
      }
    } catch (e) {
      print('❌ Get courses error: $e');
    }
    
    print('\n🏁 API testing completed!');
  }

  Future<void> testConnectivity() async {
    print('🌐 Testing basic connectivity...');
    try {
      final response = await _dio.get('${ApiConstants.baseUrl}/api/');
      print('✅ Server is reachable');
      print('Status: ${response.statusCode}');
    } catch (e) {
      print('❌ Server not reachable: $e');
      
      // Try alternative base URL variations
      final alternatives = [
        'https://web-production-d4903.up.railway.app',
        'http://web-production-d4903.up.railway.app',
      ];
      
      for (final url in alternatives) {
        try {
          print('Trying alternative URL: $url');
          final altResponse = await _dio.get('$url/api/');
          print('✅ Alternative URL works: $url');
          print('Status: ${altResponse.statusCode}');
          break;
        } catch (altError) {
          print('❌ Alternative URL failed: $url');
        }
      }
    }
  }

  Future<void> debugEndpointUrls() async {
    print('🔍 Debug: Checking endpoint URLs...');
    print('Base URL: ${ApiConstants.baseUrl}');
    print('Login: ${ApiConstants.baseUrl}${ApiConstants.loginEndpoint}');
    print('Courses: ${ApiConstants.baseUrl}${ApiConstants.coursesEndpoint}');
    print('Start Session: ${ApiConstants.baseUrl}${ApiConstants.startSessionEndpoint}');
    print('Record Attendance: ${ApiConstants.baseUrl}${ApiConstants.recordAttendanceEndpoint}');
    print('Session Attendance: ${ApiConstants.getSessionAttendanceUrl("test-session-id")}');
    print('End Session: ${ApiConstants.getEndSessionUrl("test-session-id")}');
  }
}
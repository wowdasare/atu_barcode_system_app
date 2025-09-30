import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../services/auth_service.dart';
import '../constants/api_constants.dart';
import '../utils/api_test_helper.dart';
import 'package:dio/dio.dart';

class DebugApiScreen extends StatefulWidget {
  const DebugApiScreen({super.key});

  @override
  State<DebugApiScreen> createState() => _DebugApiScreenState();
}

class _DebugApiScreenState extends State<DebugApiScreen> {
  final List<String> _logs = [];
  bool _isLoading = false;
  final ApiService _apiService = ApiService();
  final AuthService _authService = AuthService();
  final ApiTestHelper _testHelper = ApiTestHelper();

  void _addLog(String message) {
    setState(() {
      _logs.add('[${DateTime.now().toString().substring(11, 19)}] $message');
    });
  }

  void _clearLogs() {
    setState(() {
      _logs.clear();
    });
  }

  Future<void> _testConnectivity() async {
    setState(() {
      _isLoading = true;
    });

    _addLog('🌐 Testing connectivity...');
    
    try {
      final dio = Dio();
      final response = await dio.get('${ApiConstants.baseUrl}/');
      _addLog('✅ Server reachable: ${response.statusCode}');
      _addLog('Base URL: ${ApiConstants.baseUrl}');
    } catch (e) {
      _addLog('❌ Server not reachable: $e');
      
      // Try different URLs
      final alternatives = [
        'https://web-production-d4903.up.railway.app',
        'http://web-production-d4903.up.railway.app',
        'https://web-production-d4903.up.railway.app/api/',
      ];
      
      for (final url in alternatives) {
        try {
          _addLog('Trying: $url');
          final dio = Dio();
          final response = await dio.get(url);
          _addLog('✅ Alternative URL works: $url (${response.statusCode})');
          break;
        } catch (altError) {
          _addLog('❌ Failed: $url - $altError');
        }
      }
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _testLogin() async {
    setState(() {
      _isLoading = true;
    });

    _addLog('🔐 Testing login...');
    
    try {
      final response = await _authService.login('test_lecturer', 'test_password');
      if (response.success) {
        _addLog('✅ Login successful');
        _addLog('User: ${response.data?.firstName} ${response.data?.lastName}');
        _addLog('Token available: ${_authService.currentToken != null}');
      } else {
        _addLog('❌ Login failed: ${response.message}');
      }
    } catch (e) {
      _addLog('❌ Login error: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _testCourses() async {
    setState(() {
      _isLoading = true;
    });

    _addLog('📚 Testing courses API...');
    _addLog('Auth status: ${_authService.isAuthenticated}');
    _addLog('Token: ${_authService.currentToken?.substring(0, 20)}...');
    
    try {
      final response = await _apiService.getCourses();
      if (response.success && response.data != null) {
        _addLog('✅ Courses loaded: ${response.data!.length} courses');
        for (final course in response.data!) {
          _addLog('  - ${course.code}: ${course.title}');
        }
      } else {
        _addLog('❌ Courses failed: ${response.message}');
        _addLog('Status code: ${response.statusCode}');
        _addLog('Errors: ${response.errors}');
      }
    } catch (e) {
      _addLog('❌ Courses error: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _testAllEndpoints() async {
    setState(() {
      _isLoading = true;
    });

    _addLog('🧪 Running comprehensive API test...');
    
    try {
      await _testHelper.testAllEndpoints();
      _addLog('✅ Comprehensive test completed - check console for details');
    } catch (e) {
      _addLog('❌ Comprehensive test failed: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _testSessionFlow() async {
    setState(() {
      _isLoading = true;
    });

    _addLog('🎯 Testing complete session flow...');
    
    if (!_authService.isAuthenticated) {
      _addLog('❌ Not authenticated - login first');
      setState(() {
        _isLoading = false;
      });
      return;
    }

    try {
      // Test getting courses first
      final coursesResponse = await _apiService.getCourses();
      if (!coursesResponse.success || coursesResponse.data?.isEmpty == true) {
        _addLog('❌ No courses available for testing');
        setState(() {
          _isLoading = false;
        });
        return;
      }

      final firstCourse = coursesResponse.data!.first;
      _addLog('📚 Using course: ${firstCourse.title} (ID: ${firstCourse.id})');

      // Test session creation
      _addLog('🎯 Creating session...');
      final sessionResponse = await _apiService.startSession(
        courseId: firstCourse.id,
        location: 'Debug Test Room',
        notes: 'API Debug Test Session',
      );

      if (sessionResponse.success && sessionResponse.data != null) {
        final session = sessionResponse.data!;
        _addLog('✅ Session created successfully');
        _addLog('📍 Session ID: ${session.id}');
        _addLog('📍 Session ID Length: ${session.id.length}');
        _addLog('📍 Session ID Format: ${_isValidUUID(session.id) ? "Valid UUID" : "Invalid UUID"}');
        _addLog('🏢 Location: ${session.location}');

        // Wait a moment
        await Future.delayed(const Duration(seconds: 1));

        // Test ending the session
        _addLog('🔚 Ending session with ID: ${session.id}');
        final endResponse = await _apiService.endSession(session.id);

        if (endResponse.success) {
          _addLog('✅ Session ended successfully');
          if (endResponse.data != null) {
            _addLog('📊 Final session data received');
          }
        } else {
          _addLog('❌ Failed to end session: ${endResponse.message}');
          _addLog('🔍 Status Code: ${endResponse.statusCode}');
        }

      } else {
        _addLog('❌ Failed to create session: ${sessionResponse.message}');
      }

    } catch (e) {
      _addLog('💥 Session flow test error: $e');
    }

    setState(() {
      _isLoading = false;
    });
  }

  bool _isValidUUID(String uuid) {
    final uuidRegex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$'
    );
    return uuidRegex.hasMatch(uuid);
  }

  Future<void> _debugEndpoints() async {
    _addLog('🔍 Current API endpoints:');
    _addLog('Base: ${ApiConstants.baseUrl}');
    _addLog('Login: ${ApiConstants.baseUrl}${ApiConstants.loginEndpoint}');
    _addLog('Courses: ${ApiConstants.baseUrl}${ApiConstants.coursesEndpoint}');
    _addLog('Start Session: ${ApiConstants.baseUrl}${ApiConstants.startSessionEndpoint}');
    _addLog('Record Attendance: ${ApiConstants.baseUrl}${ApiConstants.recordAttendanceEndpoint}');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('API Debug'),
        backgroundColor: Colors.red.shade600,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.clear),
            onPressed: _clearLogs,
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            color: Colors.grey.shade100,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'API Debug Tools',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    ElevatedButton(
                      onPressed: _isLoading ? null : _testConnectivity,
                      child: const Text('Test Connectivity'),
                    ),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _testLogin,
                      child: const Text('Test Login'),
                    ),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _testCourses,
                      child: const Text('Test Courses'),
                    ),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _testAllEndpoints,
                      child: const Text('Test All'),
                    ),
                    ElevatedButton(
                      onPressed: _isLoading ? null : _testSessionFlow,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.purple.shade600,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Test Sessions'),
                    ),
                    ElevatedButton(
                      onPressed: _debugEndpoints,
                      child: const Text('Show URLs'),
                    ),
                  ],
                ),
                if (_isLoading)
                  const Padding(
                    padding: EdgeInsets.only(top: 16),
                    child: LinearProgressIndicator(),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16),
              child: ListView.builder(
                reverse: true,
                itemCount: _logs.length,
                itemBuilder: (context, index) {
                  final log = _logs[_logs.length - 1 - index];
                  Color textColor = Colors.black87;
                  if (log.contains('✅')) textColor = Colors.green.shade700;
                  if (log.contains('❌')) textColor = Colors.red.shade700;
                  if (log.contains('🔍') || log.contains('🌐')) textColor = Colors.blue.shade700;
                  
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      log,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        fontSize: 12,
                        color: textColor,
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
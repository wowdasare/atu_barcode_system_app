import 'package:dio/dio.dart';
import '../models/api_response.dart';
import '../models/course.dart';
import '../models/attendance_session.dart';
import '../models/attendance_record.dart';
import '../constants/api_constants.dart';
import 'auth_service.dart';

class ApiService {
  static final ApiService _instance = ApiService._internal();
  factory ApiService() => _instance;
  ApiService._internal() {
    _dio = Dio(_baseOptions);
    _setupInterceptors();
  }

  late final Dio _dio;
  final AuthService _authService = AuthService();

  BaseOptions get _baseOptions => BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: ApiConstants.connectTimeout,
    receiveTimeout: ApiConstants.receiveTimeout,
    sendTimeout: ApiConstants.sendTimeout,
    headers: {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    },
  );

  void _setupInterceptors() {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          if (_authService.isAuthenticated) {
            options.headers.addAll(_authService.getAuthHeaders());
          }
          handler.next(options);
        },
        onError: (error, handler) {
          if (error.response?.statusCode == 401) {
            _authService.clearCredentials();
          }
          handler.next(error);
        },
      ),
    );
  }

  Future<ApiResponse<String>> login(String username, String password) async {
    try {
      final response = await _dio.post(
        ApiConstants.loginEndpoint,
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200 && response.data['token'] != null) {
        return ApiResponse.success(
          response.data['token'],
          message: 'Login successful',
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          'Invalid credentials',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('Login failed: ${e.toString()}');
    }
  }

  Future<ApiResponse<Course>> getCourseDetail(int courseId) async {
    try {
      final response = await _dio.get('${ApiConstants.coursesEndpoint}$courseId/');

      if (response.statusCode == 200) {
        final course = Course.fromJson(response.data);
        return ApiResponse.success(
          course,
          message: 'Course details loaded successfully',
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          'Failed to load course details',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('Failed to load course details: ${e.toString()}');
    }
  }

  Future<ApiResponse<List<Course>>> getCourses() async {
    try {
      final response = await _dio.get(ApiConstants.coursesEndpoint);

      if (response.statusCode == 200) {
        List<Course> courses;
        
        // Debug: Print the response to understand the structure
        print('API Response for courses: ${response.data}');
        
        // Handle different response formats
        if (response.data is List) {
          // Direct array response
          final courseList = response.data as List;
          print('Processing direct array with ${courseList.length} items');
          if (courseList.isNotEmpty) {
            print('First course data: ${courseList.first}');
          }
          courses = courseList
              .map((json) => Course.fromJson(json))
              .toList();
        } else if (response.data is Map<String, dynamic>) {
          // Object response with courses property
          final data = response.data as Map<String, dynamic>;
          print('Processing object response with keys: ${data.keys}');
          
          if (data.containsKey('courses') && data['courses'] is List) {
            final courseList = data['courses'] as List;
            print('Found courses array with ${courseList.length} items');
            if (courseList.isNotEmpty) {
              print('First course data: ${courseList.first}');
            }
            courses = courseList
                .map((json) => Course.fromJson(json))
                .toList();
          } else if (data.containsKey('data') && data['data'] is List) {
            final courseList = data['data'] as List;
            print('Found data array with ${courseList.length} items');
            if (courseList.isNotEmpty) {
              print('First course data: ${courseList.first}');
            }
            courses = courseList
                .map((json) => Course.fromJson(json))
                .toList();
          } else if (data.containsKey('results') && data['results'] is List) {
            final courseList = data['results'] as List;
            print('Found results array with ${courseList.length} items');
            if (courseList.isNotEmpty) {
              print('First course data: ${courseList.first}');
            }
            courses = courseList
                .map((json) => Course.fromJson(json))
                .toList();
          } else {
            // If it's a single course object, wrap it in a list
            print('Treating as single course object: $data');
            courses = [Course.fromJson(data)];
          }
        } else {
          throw FormatException('Unexpected response format: ${response.data.runtimeType}');
        }
        
        return ApiResponse.success(
          courses,
          message: 'Courses loaded successfully',
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          'Failed to load courses',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('Failed to load courses: ${e.toString()}');
    }
  }

  Future<ApiResponse<AttendanceSession>> startSession({
    required int courseId,
    required String location,
    String? notes,
  }) async {
    try {
      final requestData = {
        'course': courseId,
        'session_name': notes ?? 'Attendance Session',
        'location': location,
      };
      
      print('🚀 Starting session with data: $requestData');
      print('🌐 URL: ${ApiConstants.baseUrl}${ApiConstants.startSessionEndpoint}');
      print('🔑 Headers: ${_authService.getAuthHeaders()}');
      
      final response = await _dio.post(
        ApiConstants.startSessionEndpoint,
        data: requestData,
      );
      
      print('📡 Start session response status: ${response.statusCode}');
      print('📝 Start session response data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        print('✅ Session creation successful, parsing response...');
        final session = AttendanceSession.fromJson(response.data);
        print('🎯 Parsed session: ID=${session.id}, Course=${session.courseName} (${session.courseCode})');
        return ApiResponse.success(
          session,
          message: 'Session started successfully',
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          'Failed to start session',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('Failed to start session: ${e.toString()}');
    }
  }

  Future<ApiResponse<AttendanceRecord>> recordAttendance({
    required String sessionId,
    required String barcodeData,
  }) async {
    try {
      final requestData = {
        'session_id': sessionId,
        'barcode_id': barcodeData,
      };
      
      print('Recording attendance with data: $requestData');
      print('URL: ${ApiConstants.baseUrl}${ApiConstants.recordAttendanceEndpoint}');
      
      final response = await _dio.post(
        ApiConstants.recordAttendanceEndpoint,
        data: requestData,
      );
      
      print('Record attendance response status: ${response.statusCode}');
      print('Record attendance response data: ${response.data}');

      if (response.statusCode == 201 || response.statusCode == 200) {
        final record = AttendanceRecord.fromJson(response.data);
        return ApiResponse.success(
          record,
          message: 'Attendance recorded successfully',
          statusCode: response.statusCode,
        );
      } else if (response.statusCode == 409) {
        return ApiResponse.error(
          'Student already marked present',
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          'Failed to record attendance',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('Failed to record attendance: ${e.toString()}');
    }
  }

  Future<ApiResponse<List<AttendanceRecord>>> getSessionAttendance(String sessionId) async {
    try {
      final url = ApiConstants.getSessionAttendanceUrl(sessionId);
      final response = await _dio.get(url);

      if (response.statusCode == 200) {
        List<AttendanceRecord> records;
        
        // Handle different response formats
        if (response.data is List) {
          // Direct array response
          records = (response.data as List)
              .map((json) => AttendanceRecord.fromJson(json))
              .toList();
        } else if (response.data is Map<String, dynamic>) {
          // Object response with records property
          final data = response.data as Map<String, dynamic>;
          if (data.containsKey('records') && data['records'] is List) {
            records = (data['records'] as List)
                .map((json) => AttendanceRecord.fromJson(json))
                .toList();
          } else if (data.containsKey('data') && data['data'] is List) {
            records = (data['data'] as List)
                .map((json) => AttendanceRecord.fromJson(json))
                .toList();
          } else if (data.containsKey('results') && data['results'] is List) {
            records = (data['results'] as List)
                .map((json) => AttendanceRecord.fromJson(json))
                .toList();
          } else {
            // If it's a single record object, wrap it in a list
            records = [AttendanceRecord.fromJson(data)];
          }
        } else {
          throw FormatException('Unexpected response format: ${response.data.runtimeType}');
        }
        
        return ApiResponse.success(
          records,
          message: 'Session attendance loaded successfully',
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          'Failed to load session attendance',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('Failed to load session attendance: ${e.toString()}');
    }
  }

  Future<ApiResponse<AttendanceSession>> endSession(String sessionId) async {
    try {
      final url = ApiConstants.getEndSessionUrl(sessionId);
      print('🔚 Ending session with ID: $sessionId');
      print('📍 Session ID Length: ${sessionId.length}');
      print('📍 Is Valid UUID Format: ${_isValidUUID(sessionId)}');
      print('🌐 Full URL: $url');
      print('🔑 Auth Headers: ${_authService.getAuthHeaders()}');
      
      final response = await _dio.post(url);
      
      print('📡 End session response status: ${response.statusCode}');
      print('📝 End session response data: ${response.data}');

      if (response.statusCode == 200) {
        final session = AttendanceSession.fromJson(response.data);
        return ApiResponse.success(
          session,
          message: 'Session ended successfully',
          statusCode: response.statusCode,
        );
      } else {
        return ApiResponse.error(
          'Failed to end session',
          statusCode: response.statusCode,
        );
      }
    } on DioException catch (e) {
      return _handleDioError(e);
    } catch (e) {
      return ApiResponse.error('Failed to end session: ${e.toString()}');
    }
  }

  ApiResponse<T> _handleDioError<T>(DioException e) {
    String message = 'Network error occurred';
    List<String>? errors;

    switch (e.type) {
      case DioExceptionType.connectionTimeout:
        message = 'Connection timeout';
        break;
      case DioExceptionType.sendTimeout:
        message = 'Send timeout';
        break;
      case DioExceptionType.receiveTimeout:
        message = 'Receive timeout';
        break;
      case DioExceptionType.badResponse:
        message = _getErrorMessage(e.response);
        errors = _getValidationErrors(e.response);
        break;
      case DioExceptionType.cancel:
        message = 'Request cancelled';
        break;
      case DioExceptionType.connectionError:
        message = 'No internet connection';
        break;
      default:
        message = 'Unknown error occurred';
    }

    return ApiResponse.error(
      message,
      errors: errors,
      statusCode: e.response?.statusCode,
    );
  }

  String _getErrorMessage(Response? response) {
    if (response == null) return 'Network error';
    
    if (response.data is Map<String, dynamic>) {
      final data = response.data as Map<String, dynamic>;
      return data['message'] ?? data['detail'] ?? 'Server error';
    }
    
    return 'HTTP ${response.statusCode}';
  }

  List<String>? _getValidationErrors(Response? response) {
    if (response?.data is Map<String, dynamic>) {
      final data = response!.data as Map<String, dynamic>;
      if (data['errors'] is List) {
        return List<String>.from(data['errors']);
      }
    }
    return null;
  }

  bool _isValidUUID(String uuid) {
    final uuidRegex = RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[1-5][0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$'
    );
    return uuidRegex.hasMatch(uuid);
  }
}
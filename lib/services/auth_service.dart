import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/foundation.dart';
import '../models/user.dart';
import '../models/api_response.dart';
import '../constants/api_constants.dart';
import '../utils/auth_debug_helper.dart';

class AuthService {
  static final AuthService _instance = AuthService._internal();
  factory AuthService() => _instance;
  AuthService._internal();

  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  late final Dio _dio;

  String? _currentToken;
  User? _currentUser;

  String? get currentToken => _currentToken;
  User? get currentUser => _currentUser;
  bool get isAuthenticated => _currentToken != null && _currentUser != null;

  Future<void> initialize() async {
    _dio = Dio(BaseOptions(
      baseUrl: ApiConstants.baseUrl,
      connectTimeout: ApiConstants.connectTimeout,
      receiveTimeout: ApiConstants.receiveTimeout,
      sendTimeout: ApiConstants.sendTimeout,
    ));
    await _loadStoredCredentials();
  }

  Future<void> _loadStoredCredentials() async {
    try {
      _currentToken = await _secureStorage.read(key: ApiConstants.tokenStorageKey);
      
      final userData = await _secureStorage.read(key: ApiConstants.userDataStorageKey);
      if (userData != null) {
        final userJson = jsonDecode(userData);
        _currentUser = User.fromJson(userJson);
      }
      
      // Debug information
      if (kDebugMode) {
        await AuthDebugHelper.debugStoredCredentials();
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error loading stored credentials: $e');
      }
      await clearCredentials();
    }
  }

  Future<ApiResponse<User>> login(String username, String password) async {
    try {
      if (username.isEmpty || password.isEmpty) {
        return ApiResponse.error('Username and password are required');
      }

      final response = await _dio.post(
        ApiConstants.loginEndpoint,
        data: {
          'username': username,
          'password': password,
        },
      );

      if (response.statusCode == 200) {
        final responseData = response.data;
        
        if (responseData['token'] != null) {
          // Extract user data and token from response
          final token = responseData['token'];
          final userData = responseData['user'] ?? responseData;
          
          final user = User.fromJson(userData);
          await _storeCredentials(token, user);
          
          return ApiResponse.success(user, message: 'Login successful');
        } else {
          return ApiResponse.error('Invalid response format from server');
        }
      } else {
        final errorMessage = response.data['message'] ?? 
                           response.data['detail'] ?? 
                           'Invalid credentials';
        return ApiResponse.error(errorMessage);
      }
    } on DioException catch (e) {
      String errorMessage = 'Login failed';
      
      if (e.type == DioExceptionType.connectionTimeout ||
          e.type == DioExceptionType.receiveTimeout) {
        errorMessage = 'Connection timeout. Please try again.';
      } else if (e.type == DioExceptionType.connectionError) {
        errorMessage = 'No internet connection. Please check your network.';
      } else if (e.response?.statusCode == 400) {
        errorMessage = e.response?.data['message'] ?? 'Invalid credentials';
      } else if (e.response?.statusCode == 401) {
        errorMessage = 'Invalid username or password';
      } else if (e.response?.statusCode == 500) {
        errorMessage = 'Server error. Please try again later.';
      }
      
      return ApiResponse.error(errorMessage);
    } catch (e) {
      return ApiResponse.error('Login failed: ${e.toString()}');
    }
  }

  Future<void> _storeCredentials(String token, User user) async {
    _currentToken = token;
    _currentUser = user;

    await _secureStorage.write(key: ApiConstants.tokenStorageKey, value: token);
    await _secureStorage.write(
      key: ApiConstants.userDataStorageKey,
      value: jsonEncode(user.toJson()),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', true);
    await prefs.setString('last_login', DateTime.now().toIso8601String());
  }

  Future<void> logout() async {
    await clearCredentials();
  }

  Future<void> clearCredentials() async {
    _currentToken = null;
    _currentUser = null;

    await _secureStorage.delete(key: ApiConstants.tokenStorageKey);
    await _secureStorage.delete(key: ApiConstants.userDataStorageKey);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('is_logged_in');
    await prefs.remove('last_login');
  }

  Map<String, String> getAuthHeaders() {
    if (_currentToken == null) {
      throw Exception('No authentication token available');
    }
    
    return {
      'Authorization': 'Token $_currentToken',
      'Content-Type': 'application/json',
    };
  }

  Future<bool> validateToken() async {
    if (_currentToken == null) return false;
    
    try {
      // Try multiple endpoints to validate token
      final endpoints = [
        ApiConstants.validateTokenEndpoint, // '/api/auth/user/'
        ApiConstants.coursesEndpoint,       // '/api/courses/' - if this works, token is valid
      ];
      
      for (final endpoint in endpoints) {
        try {
          final response = await _dio.get(
            endpoint,
            options: Options(
              headers: {'Authorization': 'Token $_currentToken'},
              validateStatus: (status) => status != null && status < 500,
              sendTimeout: const Duration(seconds: 10),
              receiveTimeout: const Duration(seconds: 10),
            ),
          );
          
          if (response.statusCode == 200) {
            // Token is valid
            if (endpoint == ApiConstants.validateTokenEndpoint) {
              // Update user data if this was the user endpoint
              try {
                final user = User.fromJson(response.data);
                _currentUser = user;
                
                await _secureStorage.write(
                  key: ApiConstants.userDataStorageKey,
                  value: jsonEncode(user.toJson()),
                );
              } catch (e) {
                // JSON parsing error, but token is still valid
                print('Warning: Could not parse user data during token validation: $e');
              }
            }
            return true;
          } else if (response.statusCode == 401) {
            // Token is definitely invalid
            await clearCredentials();
            return false;
          }
          // Continue to next endpoint if this one failed with other error
        } catch (e) {
          // Continue to next endpoint
          continue;
        }
      }
      
      // All endpoints failed - this could be network issue or server down
      // Don't clear credentials, return false to indicate validation failed
      return false;
      
    } catch (e) {
      // General exception - could be network issue
      return false;
    }
  }

  Future<ApiResponse<User>> refreshUserData() async {
    if (!isAuthenticated) {
      return ApiResponse.error('User not authenticated');
    }

    try {
      final response = await _dio.get(
        ApiConstants.validateTokenEndpoint,
        options: Options(
          headers: {'Authorization': 'Token $_currentToken'},
        ),
      );
      
      if (response.statusCode == 200) {
        final user = User.fromJson(response.data);
        _currentUser = user;
        
        // Update stored user data
        await _secureStorage.write(
          key: ApiConstants.userDataStorageKey,
          value: jsonEncode(user.toJson()),
        );
        
        return ApiResponse.success(user, message: 'User data refreshed');
      } else {
        return ApiResponse.error('Failed to refresh user data');
      }
    } catch (e) {
      return ApiResponse.error('Failed to refresh user data: ${e.toString()}');
    }
  }
}
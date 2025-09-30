import 'package:flutter/material.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  
  User? _user;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _authService.isAuthenticated && _user != null;

  Future<void> initialize() async {
    _setLoading(true);
    try {
      await _authService.initialize();
      
      // If we have stored credentials, validate the token
      if (_authService.currentToken != null && _authService.currentUser != null) {
        try {
          final isValid = await _authService.validateToken();
          if (isValid) {
            _user = _authService.currentUser;
            _clearError();
          } else {
            // Token validation failed - could be invalid token or network issue
            // Try to use stored user data temporarily and validate later
            _user = _authService.currentUser;
            _clearError();
            
            // Set a flag to indicate we need to validate later
            _scheduleTokenValidation();
          }
        } catch (e) {
          // Network error during validation - use stored credentials temporarily
          _user = _authService.currentUser;
          _clearError();
          
          // Schedule validation for later
          _scheduleTokenValidation();
        }
      } else {
        _user = null;
        _clearError();
      }
    } catch (e) {
      // On initialization error, try to use stored data if available
      if (_authService.currentUser != null) {
        _user = _authService.currentUser;
        _clearError();
        _scheduleTokenValidation();
      } else {
        _user = null;
        _setError('Failed to initialize authentication');
      }
    } finally {
      _setLoading(false);
    }
  }

  void _scheduleTokenValidation() {
    // Validate token after a delay to handle temporary network issues
    Future.delayed(const Duration(seconds: 5), () async {
      if (_user != null) {
        final isValid = await validateToken();
        if (!isValid) {
          // Token is definitely invalid, force logout
          await logout();
          _setError('Session expired. Please log in again.');
        }
      }
    });
  }

  Future<bool> login(String username, String password) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _authService.login(username, password);
      
      if (response.success) {
        _user = response.data;
        _setLoading(false);
        notifyListeners();
        return true;
      } else {
        _setError(response.message ?? 'Login failed');
        _setLoading(false);
        return false;
      }
    } catch (e) {
      _setError('Login error: ${e.toString()}');
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    try {
      await _authService.logout();
      _user = null;
      _clearError();
    } catch (e) {
      _setError('Logout error: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> validateToken() async {
    try {
      return await _authService.validateToken();
    } catch (e) {
      return false;
    }
  }

  Future<void> refreshUserData() async {
    if (!isAuthenticated) return;

    try {
      final response = await _authService.refreshUserData();
      if (response.success) {
        _user = response.data;
        notifyListeners();
      }
    } catch (e) {
      // Handle refresh error silently
    }
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _setError(String error) {
    _errorMessage = error;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
  }
}
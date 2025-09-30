import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../constants/api_constants.dart';

class AuthDebugHelper {
  static const FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  /// Check what's currently stored in secure storage
  static Future<void> debugStoredCredentials() async {
    if (kDebugMode) {
      try {
        final token = await _secureStorage.read(key: ApiConstants.tokenStorageKey);
        final userData = await _secureStorage.read(key: ApiConstants.userDataStorageKey);
        
        print('=== AUTH DEBUG ===');
        print('Stored Token: ${token != null ? 'EXISTS (${token.length} chars)' : 'NULL'}');
        print('Stored User Data: ${userData != null ? 'EXISTS' : 'NULL'}');
        
        if (token != null) {
          print('Token Preview: ${token.substring(0, token.length > 20 ? 20 : token.length)}...');
        }
        
        if (userData != null) {
          print('User Data: $userData');
        }
        print('===============');
      } catch (e) {
        print('Auth Debug Error: $e');
      }
    }
  }

  /// Clear all stored credentials (for testing)
  static Future<void> clearAllCredentials() async {
    if (kDebugMode) {
      try {
        await _secureStorage.delete(key: ApiConstants.tokenStorageKey);
        await _secureStorage.delete(key: ApiConstants.userDataStorageKey);
        print('=== AUTH DEBUG ===');
        print('All credentials cleared');
        print('===============');
      } catch (e) {
        print('Auth Debug Clear Error: $e');
      }
    }
  }

  /// Simulate invalid token (for testing token validation)
  static Future<void> simulateInvalidToken() async {
    if (kDebugMode) {
      try {
        await _secureStorage.write(key: ApiConstants.tokenStorageKey, value: 'invalid_token_for_testing');
        print('=== AUTH DEBUG ===');
        print('Invalid token set for testing');
        print('===============');
      } catch (e) {
        print('Auth Debug Simulate Error: $e');
      }
    }
  }
}
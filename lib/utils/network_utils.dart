import 'package:dio/dio.dart';

class NetworkUtils {
  static bool isNetworkError(dynamic error) {
    if (error is DioException) {
      return error.type == DioExceptionType.connectionError ||
             error.type == DioExceptionType.connectionTimeout ||
             error.type == DioExceptionType.receiveTimeout ||
             error.type == DioExceptionType.sendTimeout;
    }
    return false;
  }

  static String getErrorMessage(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return 'Connection timeout. Please check your internet connection.';
        case DioExceptionType.sendTimeout:
          return 'Send timeout. Please try again.';
        case DioExceptionType.receiveTimeout:
          return 'Receive timeout. Please try again.';
        case DioExceptionType.connectionError:
          return 'No internet connection. Please check your network settings.';
        case DioExceptionType.badResponse:
          return _getBadResponseMessage(error.response);
        case DioExceptionType.cancel:
          return 'Request was cancelled.';
        default:
          return 'Network error occurred.';
      }
    }
    return error.toString();
  }

  static String _getBadResponseMessage(Response? response) {
    if (response == null) return 'Server error occurred.';
    
    switch (response.statusCode) {
      case 400:
        return response.data['message'] ?? 'Bad request.';
      case 401:
        return 'Authentication failed. Please login again.';
      case 403:
        return 'Access forbidden. You don\'t have permission.';
      case 404:
        return 'Resource not found.';
      case 500:
        return 'Server error. Please try again later.';
      case 502:
        return 'Bad gateway. Server is temporarily unavailable.';
      case 503:
        return 'Service unavailable. Please try again later.';
      default:
        return 'Server error (${response.statusCode}).';
    }
  }

  static bool isServerError(dynamic error) {
    if (error is DioException && error.response?.statusCode != null) {
      final statusCode = error.response!.statusCode!;
      return statusCode >= 500 && statusCode < 600;
    }
    return false;
  }

  static bool isAuthError(dynamic error) {
    if (error is DioException && error.response?.statusCode != null) {
      final statusCode = error.response!.statusCode!;
      return statusCode == 401 || statusCode == 403;
    }
    return false;
  }

  static bool shouldRetry(dynamic error) {
    if (error is DioException) {
      return error.type == DioExceptionType.connectionTimeout ||
             error.type == DioExceptionType.receiveTimeout ||
             error.type == DioExceptionType.sendTimeout ||
             isServerError(error);
    }
    return false;
  }

  static Duration getRetryDelay(int attemptNumber) {
    // Exponential backoff: 1s, 2s, 4s, 8s, 16s (max)
    final seconds = (1 << (attemptNumber - 1)).clamp(1, 16);
    return Duration(seconds: seconds);
  }
}
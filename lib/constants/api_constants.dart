class ApiConstants {
  static const String baseUrl = 'https://web-production-d4903.up.railway.app';
  
  static const String loginEndpoint = '/api/auth/login/';
  static const String validateTokenEndpoint = '/api/auth/user/';
  static const String coursesEndpoint = '/api/courses/';
  static const String startSessionEndpoint = '/api/sessions/start/';
  static const String recordAttendanceEndpoint = '/api/attendance/record/';
  static const String getSessionAttendanceEndpoint = '/api/attendance/session/';
  static const String endSessionEndpoint = '/api/sessions/{session_id}/end/';
  
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  static const String tokenStorageKey = 'auth_token';
  static const String userDataStorageKey = 'user_data';
  
  static String getSessionAttendanceUrl(String sessionId) =>
      '$baseUrl$getSessionAttendanceEndpoint$sessionId/';
      
  static String getEndSessionUrl(String sessionId) =>
      '$baseUrl${endSessionEndpoint.replaceFirst('{session_id}', sessionId)}';
}
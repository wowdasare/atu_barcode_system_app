import 'package:flutter/material.dart';
import '../models/course.dart';
import '../services/api_service.dart';

class CourseProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  
  List<Course> _courses = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadCourses() async {
    _setLoading(true);
    _clearError();

    print('🔍 CourseProvider: Loading courses...');

    try {
      print('🌐 CourseProvider: Calling API getCourses()...');
      final response = await _apiService.getCourses();
      print('📡 CourseProvider: API Response - Success: ${response.success}, Data: ${response.data?.length ?? 0} courses');
      
      if (response.success && response.data != null) {
        _courses = response.data!;
        print('✅ CourseProvider: API data loaded - ${_courses.length} courses');
        _clearError();
      } else {
        print('❌ CourseProvider: API failed - ${response.message}');
        _courses = [];
        _setError('Failed to load courses: ${response.message ?? 'Unknown error'}');
      }
    } catch (e) {
      print('💥 CourseProvider: Exception caught - $e');
      _courses = [];
      _setError('Failed to load courses: ${e.toString()}');
    } finally {
      _setLoading(false);
      print('🏁 CourseProvider: Loading completed. Final course count: ${_courses.length}');
    }
  }

  Course? getCourseById(int id) {
    try {
      return _courses.firstWhere((course) => course.id == id);
    } catch (e) {
      return null;
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
import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../models/attendance_session.dart';
import '../models/attendance_record.dart';
import '../services/api_service.dart';
import '../services/scanner_service.dart';

class AttendanceProvider with ChangeNotifier {
  final ApiService _apiService = ApiService();
  final ScannerService _scannerService = ScannerService();
  
  AttendanceSession? _currentSession;
  List<AttendanceRecord> _attendanceRecords = [];
  bool _isLoading = false;
  bool _isScanning = false;
  String? _errorMessage;
  String? _lastScannedData;

  AttendanceSession? get currentSession => _currentSession;
  List<AttendanceRecord> get attendanceRecords => _attendanceRecords;
  bool get isLoading => _isLoading;
  bool get isScanning => _isScanning;
  String? get errorMessage => _errorMessage;
  String? get lastScannedData => _lastScannedData;

  Future<bool> startSession({
    required int courseId,
    required String location,
    String? notes,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.startSession(
        courseId: courseId,
        location: location,
        notes: notes,
      );
      
      if (response.success && response.data != null) {
        _currentSession = response.data;
        _attendanceRecords = [];
        _clearError();
        return true;
      } else {
        _setError('Failed to start session: ${response.message ?? 'Unknown error'}');
        return false;
      }
    } catch (e) {
      _setError('Failed to start session: ${e.toString()}');
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> endSession() async {
    if (_currentSession == null) {
      _setError('No active session to end');
      return false;
    }

    _setLoading(true);
    _clearError();

    try {
      print('Attempting to end session: ${_currentSession!.id}');
      final response = await _apiService.endSession(_currentSession!.id);
      
      if (response.success) {
        // Update session with ended data or just mark as ended
        if (response.data != null) {
          _currentSession = response.data!.copyWith(isActive: false, endTime: DateTime.now());
        } else {
          // If no data returned, manually mark as ended
          _currentSession = AttendanceSession(
            id: _currentSession!.id,
            courseId: _currentSession!.courseId,
            courseName: _currentSession!.courseName,
            courseCode: _currentSession!.courseCode,
            startTime: _currentSession!.startTime,
            endTime: DateTime.now(),
            isActive: false,
            totalAttendees: _attendanceRecords.length,
            location: _currentSession!.location,
            notes: _currentSession!.notes,
          );
        }
        _clearError();
        print('✅ Session ended successfully');
        return true;
      } else {
        final errorMsg = response.message ?? 'Failed to end session';
        print('❌ End session failed: $errorMsg');
        _setError(errorMsg);
        return false;
      }
    } catch (e) {
      final errorMsg = 'Failed to end session: ${e.toString()}';
      print('❌ End session error: $errorMsg');
      _setError(errorMsg);
      return false;
    } finally {
      _setLoading(false);
    }
  }

  Future<void> recordAttendance(String barcodeData, BarcodeFormat format) async {
    if (_currentSession == null) {
      print('❌ No active session for recording attendance');
      return;
    }

    try {
      print('🔍 Recording attendance for barcode: $barcodeData');
      _lastScannedData = barcodeData;
      notifyListeners();

      // Check if student already recorded
      final alreadyRecorded = _attendanceRecords.any(
        (record) => record.studentNumber == barcodeData
      );

      if (alreadyRecorded) {
        print('⚠️ Student already recorded');
        _setError('Student already marked present');
        return;
      }

      print('📡 Calling API to record attendance...');
      final response = await _apiService.recordAttendance(
        sessionId: _currentSession!.id,
        barcodeData: barcodeData,
      );
      
      print('📊 API Response - Success: ${response.success}, Data: ${response.data != null}');
      if (response.data != null) {
        print('🎯 Response data type: ${response.data.runtimeType}');
      }
      
      if (response.success && response.data != null) {
        _attendanceRecords.add(response.data!);
        print('✅ Added attendance record. Total count: ${_attendanceRecords.length}');
        print('📝 Record details: ${response.data!.studentName} (${response.data!.studentNumber})');
        _clearError();
        notifyListeners(); // Notify UI to update
        print('🔔 Notified listeners of attendance update');
      } else {
        print('❌ Failed to record attendance: ${response.message}');
        print('❌ Response success: ${response.success}, statusCode: ${response.statusCode}');
        _setError('Failed to record attendance: ${response.message ?? 'Unknown error'}');
      }
      
    } catch (e) {
      print('💥 Exception in recordAttendance: $e');
      _setError('Failed to record attendance: ${e.toString()}');
    }
  }

  Future<void> loadSessionAttendance() async {
    if (_currentSession == null) return;

    _setLoading(true);
    _clearError();

    try {
      final response = await _apiService.getSessionAttendance(_currentSession!.id);
      
      if (response.success && response.data != null) {
        _attendanceRecords = response.data!;
        _clearError();
      } else {
        _setError('Failed to load session attendance: ${response.message ?? 'Unknown error'}');
      }
    } catch (e) {
      _setError('Failed to load session attendance: ${e.toString()}');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> initializeScanner() async {
    try {
      final success = await _scannerService.initializeScanner();
      return success;
    } catch (e) {
      _setError('Failed to initialize scanner: ${e.toString()}');
      return false;
    }
  }

  void startScanning() {
    if (_isScanning) return;

    _isScanning = true;
    notifyListeners();

    _scannerService.startScanning(
      onDetected: (data, format) {
        recordAttendance(data, format);
      },
      onError: (error) {
        _setError(error);
        _isScanning = false;
        notifyListeners();
      },
    );
  }

  void stopScanning() {
    if (!_isScanning) return;

    _isScanning = false;
    _scannerService.stopScanning();
    notifyListeners();
  }

  Future<void> toggleTorch() async {
    await _scannerService.toggleTorch();
    notifyListeners();
  }

  Future<void> switchCamera() async {
    await _scannerService.switchCamera();
    notifyListeners();
  }

  void clearSession() {
    _currentSession = null;
    _attendanceRecords = [];
    _lastScannedData = null;
    stopScanning();
    _clearError();
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

  @override
  void dispose() {
    _scannerService.disposeScanner();
    super.dispose();
  }
}
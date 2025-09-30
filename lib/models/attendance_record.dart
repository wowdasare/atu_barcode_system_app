class AttendanceRecord {
  final int id;
  final String sessionId;
  final int studentId;
  final String studentName;
  final String studentNumber;
  final DateTime timestamp;
  final String status;
  final String? notes;

  AttendanceRecord({
    required this.id,
    required this.sessionId,
    required this.studentId,
    required this.studentName,
    required this.studentNumber,
    required this.timestamp,
    required this.status,
    this.notes,
  });

  factory AttendanceRecord.fromJson(Map<String, dynamic> json) {
    print('🔍 Creating AttendanceRecord from JSON: $json');
    
    // Parse student data with multiple fallback strategies
    final studentData = json['student'];
    String studentName = 'Unknown Student';
    String studentNumber = 'Unknown';
    int studentId = 0;
    
    if (studentData != null) {
      print('📚 Student data found: $studentData');
      
      // Try to get student name from multiple sources
      final firstName = studentData['first_name']?.toString() ?? '';
      final lastName = studentData['last_name']?.toString() ?? '';
      final fullName = studentData['name']?.toString() ?? studentData['full_name']?.toString() ?? '';
      final username = studentData['username']?.toString() ?? '';
      
      if (fullName.isNotEmpty) {
        studentName = fullName;
      } else if (firstName.isNotEmpty || lastName.isNotEmpty) {
        studentName = '$firstName $lastName'.trim();
      } else if (username.isNotEmpty) {
        studentName = username;
      }
      
      // Get student number/ID
      studentNumber = studentData['student_number']?.toString() ?? 
                     studentData['student_id']?.toString() ?? 
                     studentData['id']?.toString() ?? 
                     'Unknown';
      
      studentId = studentData['id'] ?? studentData['student_id'] ?? 0;
      
      print('👤 Parsed student: name="$studentName", number="$studentNumber", id=$studentId');
    } else {
      // Fallback to direct fields
      studentName = json['student_name']?.toString() ?? 
                   json['name']?.toString() ?? 
                   json['full_name']?.toString() ?? 
                   'Unknown Student';
      
      studentNumber = json['student_number']?.toString() ?? 
                     json['barcode_id']?.toString() ?? 
                     json['student_id']?.toString() ?? 
                     'Unknown';
      
      studentId = json['student_id'] ?? 0;
      
      print('👤 Using direct fields: name="$studentName", number="$studentNumber", id=$studentId');
    }
    
    return AttendanceRecord(
      id: json['id'] ?? DateTime.now().millisecondsSinceEpoch,
      sessionId: json['session_id']?.toString() ?? json['session']?.toString() ?? '0',
      studentId: studentId,
      studentName: studentName,
      studentNumber: studentNumber,
      timestamp: DateTime.tryParse(json['timestamp']?.toString() ?? json['created_at']?.toString() ?? json['check_in_time']?.toString() ?? '') ?? DateTime.now(),
      status: json['status']?.toString() ?? 'present',
      notes: json['notes']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'session_id': sessionId,
      'student_id': studentId,
      'student_name': studentName,
      'student_number': studentNumber,
      'timestamp': timestamp.toIso8601String(),
      'status': status,
      'notes': notes,
    };
  }

  String get formattedTime {
    return '${timestamp.hour.toString().padLeft(2, '0')}:${timestamp.minute.toString().padLeft(2, '0')}';
  }
}
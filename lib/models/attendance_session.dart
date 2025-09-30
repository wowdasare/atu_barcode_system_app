class AttendanceSession {
  final String id;
  final int courseId;
  final String courseName;
  final String courseCode;
  final DateTime startTime;
  final DateTime? endTime;
  final bool isActive;
  final int totalAttendees;
  final String location;
  final String? notes;

  AttendanceSession({
    required this.id,
    required this.courseId,
    required this.courseName,
    required this.courseCode,
    required this.startTime,
    this.endTime,
    required this.isActive,
    required this.totalAttendees,
    required this.location,
    this.notes,
  });

  factory AttendanceSession.fromJson(Map<String, dynamic> json) {
    // Parse course data from the nested course object
    final courseData = json['course'];
    String courseName = 'Unknown Course';
    String courseCode = 'UNKNOWN';
    int courseId = 0;
    
    if (courseData != null) {
      courseName = courseData['course_name'] ?? courseData['title'] ?? courseData['name'] ?? 'Unknown Course';
      courseCode = courseData['course_code'] ?? courseData['code'] ?? 'UNKNOWN';
      courseId = courseData['id'] ?? 0;
    } else {
      // Fallback to direct fields if course object is not nested
      courseName = json['course_name'] ?? 'Unknown Course';
      courseCode = json['course_code'] ?? 'UNKNOWN';
      courseId = json['course_id'] ?? json['course'] ?? 0;
    }
    
    return AttendanceSession(
      id: json['session_id']?.toString() ?? json['id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
      courseId: courseId,
      courseName: courseName,
      courseCode: courseCode,
      startTime: DateTime.tryParse(json['start_time'] ?? json['created_at'] ?? '') ?? DateTime.now(),
      endTime: json['end_time'] != null ? DateTime.tryParse(json['end_time']) : null,
      isActive: json['is_active'] ?? json['active'] ?? json['status'] == 'active',
      totalAttendees: json['total_attendees'] ?? json['attendee_count'] ?? 0,
      location: json['location'] ?? '',
      notes: json['notes'] ?? json['session_name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'course_id': courseId,
      'course_name': courseName,
      'course_code': courseCode,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime?.toIso8601String(),
      'is_active': isActive,
      'total_attendees': totalAttendees,
      'location': location,
      'notes': notes,
    };
  }

  Duration get duration {
    final end = endTime ?? DateTime.now();
    final calculatedDuration = end.difference(startTime);
    print('⏰ Duration calculation: start=$startTime, end=$end, duration=${calculatedDuration.inMinutes}m');
    return calculatedDuration;
  }

  String get formattedDuration {
    final duration = this.duration;
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final formatted = '${hours}h ${minutes}m';
    print('📊 Formatted duration: $formatted (from ${duration.inMinutes} total minutes)');
    return formatted;
  }

  AttendanceSession copyWith({
    String? id,
    int? courseId,
    String? courseName,
    String? courseCode,
    DateTime? startTime,
    DateTime? endTime,
    bool? isActive,
    int? totalAttendees,
    String? location,
    String? notes,
  }) {
    return AttendanceSession(
      id: id ?? this.id,
      courseId: courseId ?? this.courseId,
      courseName: courseName ?? this.courseName,
      courseCode: courseCode ?? this.courseCode,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      isActive: isActive ?? this.isActive,
      totalAttendees: totalAttendees ?? this.totalAttendees,
      location: location ?? this.location,
      notes: notes ?? this.notes,
    );
  }
}
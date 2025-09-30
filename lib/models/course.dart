class Course {
  final int id;
  final String code;
  final String title;
  final String description;
  final int lecturerId;
  final String lecturerName;
  final int totalStudents;

  Course({
    required this.id,
    required this.code,
    required this.title,
    required this.description,
    required this.lecturerId,
    required this.lecturerName,
    required this.totalStudents,
  });

  factory Course.fromJson(Map<String, dynamic> json) {
    print('🔍 Creating Course from JSON: $json');
    
    // Parse according to backend API format
    final courseName = json['course_name'] ?? json['title'] ?? json['name'] ?? '';
    final courseCode = json['course_code'] ?? json['code'] ?? '';
    final lecturerData = json['lecturer'];
    String lecturerName = '';
    int lecturerId = 0;
    
    if (lecturerData != null) {
      lecturerName = lecturerData['full_name'] ?? lecturerData['name'] ?? '';
      lecturerId = lecturerData['id'] ?? 0;
    }
    
    print('🎯 Extracted courseName: "$courseName"');
    print('📝 Extracted courseCode: "$courseCode"'); 
    print('👨‍🏫 Extracted lecturerName: "$lecturerName"');
    
    return Course(
      id: json['id'] ?? 0,
      code: courseCode,
      title: courseName,
      description: json['description'] ?? '',
      lecturerId: lecturerId,
      lecturerName: lecturerName,
      totalStudents: json['students_count'] ?? json['total_students'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'code': code,
      'title': title,
      'description': description,
      'lecturer_id': lecturerId,
      'lecturer_name': lecturerName,
      'total_students': totalStudents,
    };
  }
}
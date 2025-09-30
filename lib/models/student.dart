class Student {
  final int id;
  final String studentId;
  final String firstName;
  final String lastName;
  final String email;
  final String program;
  final int yearLevel;
  final String barcodeData;

  Student({
    required this.id,
    required this.studentId,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.program,
    required this.yearLevel,
    required this.barcodeData,
  });

  factory Student.fromJson(Map<String, dynamic> json) {
    return Student(
      id: json['id'] ?? 0,
      studentId: json['student_id'] ?? '',
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      program: json['program'] ?? '',
      yearLevel: json['year_level'] ?? 1,
      barcodeData: json['barcode_data'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'student_id': studentId,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'program': program,
      'year_level': yearLevel,
      'barcode_data': barcodeData,
    };
  }

  String get fullName => '$firstName $lastName';
}
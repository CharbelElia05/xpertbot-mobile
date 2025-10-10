class UserModel {
  final String id;
  final String name;
  final String email;
  final DateTime? createdAt;
  final int completedCourses;
  final int totalProgress;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    this.createdAt,
    this.completedCourses = 0,
    this.totalProgress = 0,
  });

  // Convert from Firestore document to UserModel
  factory UserModel.fromFirestore(Map<String, dynamic> data, String id) {
    return UserModel(
      id: id,
      name: data['name'] ?? '',
      email: data['email'] ?? '',
      createdAt: data['createdAt']?.toDate(),
      completedCourses: data['completedCourses'] ?? 0,
      totalProgress: data['totalProgress'] ?? 0,
    );
  }

  // Convert UserModel to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'createdAt': createdAt,
      'completedCourses': completedCourses,
      'totalProgress': totalProgress,
    };
  }
}

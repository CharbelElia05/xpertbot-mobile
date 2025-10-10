import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../services/course_service.dart';

class CourseController with ChangeNotifier {
  final CourseService _courseService = CourseService();

  List<Course> _courses = [];
  bool _isLoading = false;
  String? _error;

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
  String? get error => _error;

  // Load courses for a track
  Future<void> loadCourses(String trackId) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      // For now, using hardcoded data as fallback
      _courses = _getHardcodedCourses(trackId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      _error = "Failed to load courses: ${e.toString()}";
      notifyListeners();
    }
  }

  // Your existing hardcoded data as fallback
  List<Course> _getHardcodedCourses(String trackId) {
    if (trackId == 'web') {
      return [
        Course(
          id: '1',
          title: 'Git & Github',
          trackId: 'web',
          lessonCount: 4,
          imageUrl: 'assets/images/github_logo.png',
          videoId: 'RGOj5yH7evk',
        ),
        Course(
          id: '2',
          title: 'Web Development Basics',
          trackId: 'web',
          lessonCount: 1,
          imageUrl: 'assets/images/question_mark.png',
          videoId: 'qz0aGYrrlhU',
        ),
      ];
    } else if (trackId == 'mobile') {
      return [
        Course(
          id: '3',
          title: 'Flutter Introduction',
          trackId: 'mobile',
          lessonCount: 4,
          imageUrl: 'assets/images/flutter.png',
          videoId: 'x0uinJvhNxI',
        ),
        Course(
          id: '4',
          title: 'Dart Programming',
          trackId: 'mobile',
          lessonCount: 1,
          imageUrl: 'assets/images/dart.png',
          videoId: 'Ej_PC4nDTsw',
        ),
      ];
    }
    return [];
  }

  void clearError() {
    _error = null;
    notifyListeners();
  }
}

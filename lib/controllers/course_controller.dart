import 'package:flutter/material.dart';
import '../models/course_model.dart';
import '../services/course_service.dart';
import '../services/offline_service.dart'; // Add this import

class CourseController with ChangeNotifier {
  final CourseService _courseService = CourseService();

  List<Course> _courses = [];
  bool _isLoading = false;
  String? _error;
  bool _isOfflineData = false; // ← ADD THIS

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isOfflineData => _isOfflineData; // ← ADD THIS GETTER

  // Load courses for a track
  Future<void> loadCourses(String trackId) async {
    _isLoading = true;
    _error = null;
    _isOfflineData = false; // ← SET DEFAULT
    notifyListeners();

    try {
      // Check if offline and has cached data
      final isOnline = await OfflineService.isConnected;

      if (!isOnline) {
        final cachedCourses = OfflineService.getCachedCourses(trackId);
        if (cachedCourses != null) {
          // Use cached data when offline
          _courses = cachedCourses.map((data) => Course.fromMap(data)).toList();
          _isOfflineData = true; // ← MARK AS OFFLINE DATA
        } else {
          // No cached data available offline
          _courses = _getHardcodedCourses(trackId);
        }
      } else {
        // Online - use normal data and cache it
        _courses = _getHardcodedCourses(trackId);

        // Cache courses for offline use
        final coursesData = _courses
            .map(
              (course) => {
                'id': course.id,
                'title': course.title,
                'trackId': course.trackId,
                'lessonCount': course.lessonCount,
                'imageUrl': course.imageUrl,
                'videoId': course.videoId,
              },
            )
            .toList();

        await OfflineService.cacheCourses(trackId, coursesData);
      }

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

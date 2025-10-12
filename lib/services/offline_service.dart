import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OfflineService {
  static final Connectivity _connectivity = Connectivity();
  static late SharedPreferences _prefs;

  // Initialize - call this in main.dart
  static Future<void> initialize() async {
    _prefs = await SharedPreferences.getInstance();
  }

  // Connectivity check
  static Future<bool> get isConnected async {
    final connectivityResult = await _connectivity.checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  // Connectivity stream
  static Stream<bool> get connectivityStream {
    return _connectivity.onConnectivityChanged.map(
      (result) => result != ConnectivityResult.none,
    );
  }

  // === SIMPLE CACHE METHODS ===

  // Cache courses for a track
  static Future<void> cacheCourses(
    String trackId,
    List<Map<String, dynamic>> courses,
  ) async {
    // Convert to JSON string
    final coursesJson = courses
        .map(
          (course) =>
              '${course['id']}|${course['title']}|${course['imageUrl']}|${course['videoId']}|${course['lessonCount']}',
        )
        .toList();
    await _prefs.setStringList('courses_$trackId', coursesJson);
  }

  // Get cached courses
  static List<Map<String, dynamic>>? getCachedCourses(String trackId) {
    final coursesJson = _prefs.getStringList('courses_$trackId');
    if (coursesJson == null) return null;

    // Convert back from JSON string
    return coursesJson.map((courseStr) {
      final parts = courseStr.split('|');
      return {
        'id': parts[0],
        'title': parts[1],
        'imageUrl': parts[2],
        'videoId': parts[3],
        'lessonCount': int.tryParse(parts[4]) ?? 1,
        'trackId': trackId,
      };
    }).toList();
  }

  // Check if courses are cached
  static bool hasCachedCourses(String trackId) {
    return _prefs.containsKey('courses_$trackId');
  }

  // Save last opened course (for quick access)
  static Future<void> saveLastOpenedCourse(
    String trackId,
    String courseId,
  ) async {
    await _prefs.setString('last_course', '$trackId|$courseId');
  }

  // Get last opened course
  static Map<String, String>? getLastOpenedCourse() {
    final lastCourse = _prefs.getString('last_course');
    if (lastCourse == null) return null;

    final parts = lastCourse.split('|');
    return {'trackId': parts[0], 'courseId': parts[1]};
  }

  // Clear cache (optional)
  static Future<void> clearCache() async {
    final keys = _prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith('courses_') || key == 'last_course') {
        await _prefs.remove(key);
      }
    }
  }
}

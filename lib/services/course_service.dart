import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/course_model.dart';

class CourseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get all courses for a specific track
  Stream<List<Course>> getCoursesByTrack(String trackId) {
    return _firestore
        .collection('courses')
        .where('trackId', isEqualTo: trackId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            return Course.fromFirestore(doc.data(), doc.id);
          }).toList();
        });
  }
}

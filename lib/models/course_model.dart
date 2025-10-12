class Course {
  final String id;
  final String title;
  final String trackId;
  final int lessonCount;
  final String imageUrl;
  final String videoId;
  final String? description;

  Course({
    required this.id,
    required this.title,
    required this.trackId,
    required this.lessonCount,
    required this.imageUrl,
    required this.videoId,
    this.description,
  });

  // Convert from Firestore document
  factory Course.fromFirestore(Map<String, dynamic> data, String id) {
    return Course(
      id: id,
      title: data['title'] ?? '',
      trackId: data['trackId'] ?? '',
      lessonCount: data['lessonCount'] ?? 0,
      imageUrl: data['imageUrl'] ?? '',
      videoId: data['videoId'] ?? '',
      description: data['description'],
    );
  }

  // ← ADD THESE TWO METHODS:

  // Convert from Map (for cached data)
  factory Course.fromMap(Map<String, dynamic> data) {
    return Course(
      id: data['id'] ?? '',
      title: data['title'] ?? '',
      trackId: data['trackId'] ?? '',
      lessonCount: data['lessonCount'] ?? 0,
      imageUrl: data['imageUrl'] ?? '',
      videoId: data['videoId'] ?? '',
      description: data['description'],
    );
  }

  // Convert to Map (for caching)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'trackId': trackId,
      'lessonCount': lessonCount,
      'imageUrl': imageUrl,
      'videoId': videoId,
      'description': description,
    };
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'video_player_screen.dart';
import '../services/offline_service.dart';
import '../controllers/course_controller.dart';
import '../models/course_model.dart';

class CoursesScreen extends StatefulWidget {
  final String trackId;
  final String trackTitle;

  const CoursesScreen({
    super.key,
    required this.trackId,
    required this.trackTitle,
  });

  @override
  State<CoursesScreen> createState() => _CoursesScreenState();
}

class _CoursesScreenState extends State<CoursesScreen> {
  @override
  void initState() {
    super.initState();
    // Load courses when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final courseController = Provider.of<CourseController>(
        context,
        listen: false,
      );
      courseController.loadCourses(widget.trackId);
    });
  }

  @override
  Widget build(BuildContext context) {
    final courseController = Provider.of<CourseController>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.trackTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          StreamBuilder<bool>(
            stream: OfflineService.connectivityStream,
            builder: (context, snapshot) {
              final isOnline = snapshot.data ?? true;
              return Padding(
                padding: const EdgeInsets.only(right: 16),
                child: Icon(
                  isOnline ? Icons.wifi : Icons.wifi_off,
                  color: isOnline ? Colors.green : Colors.grey,
                  size: 20,
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Offline Banner
          StreamBuilder<bool>(
            stream: OfflineService.connectivityStream,
            builder: (context, snapshot) {
              final isOnline = snapshot.data ?? true;
              if (isOnline) return const SizedBox.shrink();

              return Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(
                  vertical: 8,
                  horizontal: 16,
                ),
                color: Colors.orange[100],
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off, size: 16, color: Colors.orange[800]),
                    const SizedBox(width: 8),
                    Text(
                      'You are offline - showing cached content',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.orange[800],
                        fontFamily: 'Poppins',
                      ),
                    ),
                  ],
                ),
              );
            },
          ),

          // Error Message
          if (courseController.error != null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(12),
              color: Colors.red[50],
              child: Row(
                children: [
                  const Icon(Icons.error_outline, color: Colors.red),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      courseController.error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, size: 16),
                    onPressed: () => courseController.clearError(),
                  ),
                ],
              ),
            ),

          Expanded(child: _buildContent(courseController)),
        ],
      ),
    );
  }

  Widget _buildContent(CourseController courseController) {
    // Show loading indicator
    if (courseController.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    // Show empty state
    if (courseController.courses.isEmpty) {
      return const Center(
        child: Text(
          'No courses available for this track',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
      );
    }

    // Show courses list
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildTrackHeader(),
          const SizedBox(height: 24),
          _buildCoursesList(courseController.courses),
        ],
      ),
    );
  }

  Widget _buildCoursesList(List<Course> courses) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Available Courses',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: Color(0xFF3E4C81),
          ),
        ),
        const SizedBox(height: 16),
        ...courses.map((course) => _buildCourseItem(course)).toList(),
      ],
    );
  }

  Widget _buildCourseItem(Course course) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: const Color(0xFF3E4C81).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8),
            child: Image.asset(
              course.imageUrl,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.school, color: Color(0xFF3E4C81));
              },
            ),
          ),
        ),
        title: Text(
          course.title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            '${course.lessonCount} ${course.lessonCount == 1 ? 'lesson' : 'lessons'}',
            style: const TextStyle(
              fontSize: 14,
              color: Colors.grey,
              fontFamily: 'Poppins',
            ),
          ),
        ),
        trailing: Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF3E4C81).withOpacity(0.1),
            borderRadius: BorderRadius.circular(18),
          ),
          child: const Icon(Icons.chevron_right, color: Color(0xFF3E4C81)),
        ),
        onTap: () {
          _navigateToVideoPlayer(context, course.title, course.videoId);
        },
      ),
    );
  }

  Widget _buildTrackHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF3E4C81).withOpacity(0.8),
            const Color(0xFF3E4C81).withOpacity(0.6),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            widget.trackTitle,
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
              fontFamily: 'Poppins',
            ),
          ),
          const SizedBox(height: 8),
          Text(
            _getTrackDescription(),
            style: const TextStyle(
              fontSize: 16,
              color: Colors.white70,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  String _getTrackDescription() {
    if (widget.trackId == 'web') {
      return 'Learn HTML, CSS, JavaScript and build modern websites';
    } else if (widget.trackId == 'mobile') {
      return 'Build cross-platform mobile apps with Flutter and Dart';
    }
    return 'Master development skills with expert-led courses';
  }

  void _navigateToVideoPlayer(
    BuildContext context,
    String lessonTitle,
    String videoId,
  ) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) =>
            VideoPlayerScreen(videoId: videoId, lessonTitle: lessonTitle),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'video_player_screen.dart';
import '../services/offline_service.dart'; // Add this import

class CoursesScreen extends StatelessWidget {
  final String trackId;
  final String trackTitle;

  const CoursesScreen({
    super.key,
    required this.trackId,
    required this.trackTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(trackTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
        actions: [
          // 🔥 OFFLINE INDICATOR - Add this
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
          // 🔥 OFFLINE BANNER - Add this
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
                      'You are offline - some features may be limited',
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

          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Track Header
                  _buildTrackHeader(),
                  const SizedBox(height: 24),

                  // Show DIFFERENT courses based on which track was tapped
                  if (trackId == 'web') ..._buildWebDevelopmentCourses(context),
                  if (trackId == 'mobile')
                    ..._buildMobileDevelopmentCourses(context),
                ],
              ),
            ),
          ),
        ],
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
            trackTitle,
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
    if (trackId == 'web') {
      return 'Learn HTML, CSS, JavaScript and build modern websites';
    } else if (trackId == 'mobile') {
      return 'Build cross-platform mobile apps with Flutter and Dart';
    }
    return 'Master development skills with expert-led courses';
  }

  // WEB DEVELOPMENT COURSES
  List<Widget> _buildWebDevelopmentCourses(BuildContext context) {
    return [
      _buildSection(
        title: 'Web Development Fundamentals',
        items: [
          _buildCourseItem(
            title: 'Git & Github',
            lessonCount: '4 lessons',
            imageAsset: 'assets/images/github_logo.png',
            onTap: () {
              _navigateToVideoPlayer(
                context,
                'Git & GitHub Complete Guide',
                'RGOj5yH7evk',
              );
            },
          ),
          _buildCourseItem(
            title: 'Web Development Basics',
            lessonCount: '1 lesson',
            imageAsset: 'assets/images/question_mark.png',
            onTap: () {
              _navigateToVideoPlayer(
                context,
                'Web Development Common Knowledge',
                'qz0aGYrrlhU',
              );
            },
          ),
        ],
      ),
    ];
  }

  // MOBILE DEVELOPMENT COURSES
  List<Widget> _buildMobileDevelopmentCourses(BuildContext context) {
    return [
      _buildSection(
        title: 'Mobile App Development',
        items: [
          _buildCourseItem(
            title: 'Flutter Introduction',
            lessonCount: '4 lessons',
            imageAsset: 'assets/images/flutter.png',
            onTap: () {
              _navigateToVideoPlayer(
                context,
                'Flutter Tutorial for Beginners',
                'x0uinJvhNxI',
              );
            },
          ),
          _buildCourseItem(
            title: 'Dart Programming',
            lessonCount: '1 lesson',
            imageAsset: 'assets/images/dart.png',
            onTap: () {
              _navigateToVideoPlayer(
                context,
                'Dart Programming Basics',
                'Ej_PC4nDTsw',
              );
            },
          ),
        ],
      ),
    ];
  }

  Widget _buildSection({required String title, required List<Widget> items}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            fontFamily: 'Poppins',
            color: Color(0xFF3E4C81),
          ),
        ),
        const SizedBox(height: 16),
        ...items,
      ],
    );
  }

  Widget _buildCourseItem({
    required String title,
    required String lessonCount,
    required String imageAsset,
    required VoidCallback onTap,
  }) {
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
              imageAsset,
              fit: BoxFit.contain,
              cacheWidth: 100, // Optimize image caching
              cacheHeight: 100,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(Icons.school, color: Color(0xFF3E4C81));
              },
            ),
          ),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            fontFamily: 'Poppins',
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            lessonCount,
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
        onTap: onTap,
      ),
    );
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

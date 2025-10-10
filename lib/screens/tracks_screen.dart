import 'package:flutter/material.dart';
import 'courses_screen.dart';

class TracksScreen extends StatelessWidget {
  const TracksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Learning Tracks'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Choose Your Track',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Start your learning journey with expert-led tracks',
              style: TextStyle(
                fontSize: 16,
                color: Colors.grey,
                fontFamily: 'Poppins',
              ),
            ),
            const SizedBox(height: 32),

            // Only 2 Tracks
            Expanded(
              child: ListView(
                children: [
                  // Web Development Track
                  _buildTrackCard(
                    title: 'Web Development',
                    description: 'Build modern websites and web applications',
                    courses: '5 Courses',
                    progress: 60,
                    imageAsset: 'assets/images/web_course.png',
                    color: const Color(0xFF3E4C81),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CoursesScreen(
                            trackId: 'web',
                            trackTitle: 'Web Development',
                          ),
                        ),
                      );
                    },
                  ),
                  const SizedBox(height: 20),

                  // Mobile Development Track
                  _buildTrackCard(
                    title: 'Mobile Development',
                    description: 'Create cross-platform mobile apps',
                    courses: '4 Courses',
                    progress: 37,
                    imageAsset: 'assets/images/mobile_course.png',
                    color: const Color(0xFF4CAF50),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CoursesScreen(
                            trackId: 'mobile',
                            trackTitle: 'Mobile Development',
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTrackCard({
    required String title,
    required String description,
    required String courses,
    required int progress,
    required String imageAsset,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Row(
            children: [
              // Track Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  image: DecorationImage(
                    image: AssetImage(imageAsset),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              const SizedBox(width: 20),

              // Track Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      description,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.grey,
                        fontFamily: 'Poppins',
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        _buildTrackInfo(Icons.school, courses),
                        const SizedBox(width: 16),
                        _buildTrackInfo(Icons.bar_chart, '$progress% Progress'),
                      ],
                    ),
                    const SizedBox(height: 8),
                    LinearProgressIndicator(
                      value: progress / 100,
                      backgroundColor: Colors.grey[200],
                      color: color,
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ],
                ),
              ),

              // Chevron
              const Icon(Icons.chevron_right, color: Colors.grey, size: 30),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTrackInfo(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: Colors.grey),
        const SizedBox(width: 4),
        Text(
          text,
          style: const TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontFamily: 'Poppins',
          ),
        ),
      ],
    );
  }
}

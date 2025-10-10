import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'register_screen.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    const Color primaryColor = Color(0xFF3E4C81);
    const Color secondaryColor = Color(0xFF9CD5C2);

    return Scaffold(
      appBar: AppBar(
        title: const Text('About XpertBot'),
        backgroundColor: primaryColor,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Section
            Center(
              child: Text(
                'About XpertBot',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 24),

            // Main Content
            _buildParagraph(
              'A comprehensive online learning academy offering expert-led courses and professional development programs. '
              'Specializing in technology, business, and skill-building education, XpertBot provides interactive learning '
              'experiences with industry-certified instructors. Our platform is designed to help learners of all levels '
              'master new skills, enhance career opportunities, and stay ahead in a fast-changing world. With hands-on '
              'projects, real-world case studies, and personalized learning paths, XpertBot ensures every student can '
              'achieve their learning goals effectively and efficiently. Join our community today and start your journey '
              'toward knowledge, growth, and success.',
            ),

            const SizedBox(height: 20),

            _buildParagraph(
              'At XpertBot, we believe learning should be engaging, flexible, and accessible to everyone. That\'s why '
              'our courses are available online anytime, anywhere, allowing learners to progress at their own pace. '
              'We cover a wide range of subjects, from coding, artificial intelligence, and cybersecurity to leadership, '
              'entrepreneurship, and creative skills. Our instructors are industry professionals who bring real-world '
              'experience into every lesson, ensuring you gain practical knowledge that can be applied immediately.',
            ),

            const SizedBox(height: 20),

            _buildParagraph(
              'Beyond individual learning, XpertBot fosters a collaborative community where learners can connect, '
              'share insights, and work together on projects. Our interactive quizzes, discussion forums, and '
              'peer-reviewed assignments encourage active participation, helping students deepen their understanding '
              'and retain knowledge longer. Whether you are starting your career, switching industries, or simply '
              'curious to learn new skills, XpertBot is your partner in lifelong learning.',
            ),

            const SizedBox(height: 20),

            _buildParagraph(
              'Explore our growing library of courses, engage with expert instructors, and take advantage of our tools '
              'designed to track your progress and celebrate your achievements. With XpertBot, learning is not just '
              'about acquiring information—it\'s about transforming your skills, building confidence, and achieving '
              'your personal and professional goals.',
            ),

            const SizedBox(height: 40),

            // Learning Tracks Section
            Center(
              child: Text(
                'Our Learning Tracks',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: primaryColor,
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Learning Tracks Grid
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 0.8,
              children: [
                _buildLearningTrackCard(
                  title: 'Mobile Development',
                  description:
                      'Create fast, cross-platform mobile apps with Flutter.',
                  icon: Icons.phone_android,
                  color: primaryColor,
                ),
                _buildLearningTrackCard(
                  title: 'Web Development',
                  description:
                      'Build secure and modern web applications with Laravel.',
                  icon: Icons.web,
                  color: secondaryColor,
                ),
                _buildLearningTrackCard(
                  title: 'Artificial Intelligence',
                  description:
                      'Learn machine learning, neural networks, and smart systems',
                  icon: Icons.smart_toy,
                  color: primaryColor,
                ),
                _buildLearningTrackCard(
                  title: 'Project Management',
                  description:
                      'Master Agile and Scrum to lead projects effectively',
                  icon: Icons.assignment,
                  color: secondaryColor,
                ),
                _buildLearningTrackCard(
                  title: 'Cybersecurity',
                  description:
                      'Protect networks and data with essential security skills.',
                  icon: Icons.security,
                  color: primaryColor,
                ),
                _buildLearningTrackCard(
                  title: 'Quality Assurance',
                  description:
                      'Test, debug, and ensure reliable, high-quality software.',
                  icon: Icons.bug_report,
                  color: secondaryColor,
                ),
              ],
            ),

            const SizedBox(height: 30),

            // Call to Action Section
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: secondaryColor.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: secondaryColor),
              ),
              child: Column(
                children: [
                  Icon(Icons.school, size: 40, color: primaryColor),
                  const SizedBox(height: 10),
                  Text(
                    'Ready to start learning?',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: primaryColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Join XpertBot today and explore your potential!',
                    style: Theme.of(
                      context,
                    ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),

                  // Sign up and Login buttons
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          _navigateToRegisterScreen(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                        ),
                        child: const Text('Sign up'),
                      ),
                      const SizedBox(width: 16),
                      OutlinedButton(
                        onPressed: () {
                          _navigateToLoginScreen(context);
                        },
                        style: OutlinedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 12,
                          ),
                          side: BorderSide(color: primaryColor),
                        ),
                        child: Text(
                          'Login',
                          style: TextStyle(color: primaryColor),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 40), // Extra space at bottom for scrolling
          ],
        ),
      ),
    );
  }

  Widget _buildParagraph(String text) {
    return Text(
      text,
      style: const TextStyle(fontSize: 16, height: 1.6, color: Colors.black87),
      textAlign: TextAlign.justify,
    );
  }

  Widget _buildLearningTrackCard({
    required String title,
    required String description,
    required IconData icon,
    required Color color,
  }) {
    return Card(
      elevation: 3,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: color),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: color,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: const TextStyle(fontSize: 12, color: Colors.black87),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  // Navigation methods
  void _navigateToLoginScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _navigateToRegisterScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterScreen()),
    );
  }
}

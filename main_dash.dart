import 'package:flutter/material.dart';

void main() {
  runApp(const AdminDashboard());
}

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _AdminDashboardState createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  bool _isHovered = false;

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Admin Dashboard'),
        ),
        backgroundColor: Colors.grey[300],
        body: Row(
          children: [
            // Sidebar
            InkWell(
              onTap: () {
                setState(() {
                  _isHovered = !_isHovered;
                });
              },
              child: MouseRegion(
                onEnter: (_) => setState(() => _isHovered = true),
                onExit: (_) => setState(() => _isHovered = false),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: _isHovered ? 200 : 50,
                  color: Colors.grey[800],
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),
                      _isHovered
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildMenuItem(Icons.dashboard, 'Dashboard'),
                                _buildMenuItem(Icons.verified_user_sharp, 'Attendance'),
                                _buildMenuItem(Icons.verified_user_sharp, 'Employees'),
                                _buildMenuItem(Icons.logout, 'Logout'),
                              ],
                            )
                          : const SizedBox(),
                    ],
                  ),
                ),
              ),
            ),

            // Main Content
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(20),
                child: const Center(
                  child: Text('Main Content', style: TextStyle(fontSize: 24)),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuItem(IconData icon, String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: Colors.white),
          const SizedBox(width: 10),
          Text(text, style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'admin_attendance_page.dart';
import 'admin_employee_detail.dart';
import 'admin_login.dart';
import 'email_page.dart'; // Import the EmailPage class

class HelloAdminPage extends StatelessWidget {
  const HelloAdminPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hello Admin'),
      ),
      drawer: const AdminDrawer(),
      body: Center(
        child: Container(
          width: double.infinity, // Set width to match the screen width
          padding: const EdgeInsets.all(16.0), // Add padding for spacing
          color: Colors.white, // Set background color to blue
          child: const Text(
            'Welcome, Admin!',
            style: TextStyle(
              color: Colors.blueAccent, // Set text color to white
              fontSize: 27, // Increase font size
              fontWeight: FontWeight.bold, // Make text bold
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class AdminDrawer extends StatelessWidget {
  const AdminDrawer({Key? key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        children: [
          ListTile(
            title: const Text('Dashboard'),
            onTap: () {
              // Handle dashboard navigation
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const HelloAdminPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Attendance'),
            onTap: () {
              // Handle dashboard navigation
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const AdminAttendancePage()),
              );
            },
          ),
          ListTile(
            title: const Text('Employees'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EmployeeDetailPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Email'),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const EmailPage()),
              );
            },
          ),
          ListTile(
            title: const Text('Logout'),
            onTap: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => const LoginPage()),
              );
            },
          ),
        ],
      ),
    );
  }
}


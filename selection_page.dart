import 'package:flutter/material.dart';
import 'admin_login.dart';
import 'user_login.dart'; // Import the login page

class SelectionPage extends StatelessWidget {
  const SelectionPage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.white, Colors.white], // Change the colors here
          ),
        ),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Your company logo
              Image.asset(
                'assets/images/logo.png', // Replace 'company_logo.png' with your actual logo asset
                width: 200, // Adjust width as needed
                height: 200, // Adjust height as needed
              ),
              const SizedBox(height: 10), // Add spacing between logo and company name
              // Your company name
              Text(
                'Employee Attendance App',
                style: TextStyle(
                  fontSize: 30,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to Admin login page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const LoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue[400],
                  elevation: 3,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 48), // Adjust button padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Adjust button border radius
                  ),
                  shadowColor: Colors.blue.withOpacity(0.5), // Add button shadow
                ),
                icon: const Icon(Icons.admin_panel_settings),
                label: const Text(
                  'Admin Login',
                  style: TextStyle(fontSize: 18),
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  // Navigate to User login page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => UserLoginPage()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.blue[400],
                  elevation: 3,
                  padding: EdgeInsets.symmetric(vertical: 15, horizontal: 35), // Adjust button padding
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30), // Adjust button border radius
                  ),
                  shadowColor: Colors.blue.withOpacity(0.5), // Add button shadow
                ),
                icon: const Icon(Icons.person),
                label: const Text(
                  'Employee Login',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
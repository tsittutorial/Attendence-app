import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'response_page.dart';
import 'user_login.dart'; // Import UserLoginPage

import 'email.dart'; // Import EmailPage

class UserForm extends StatefulWidget {
  final String username; // Add username parameter

  const UserForm({Key? key, required this.username}) : super(key: key);

  @override
  _UserFormState createState() => _UserFormState();
}

class _UserFormState extends State<UserForm> {
  String name = '';

  @override
  void initState() {
    super.initState();
    name = widget.username; // Set the username in the name field
  }

  DateTime? selectedDate;
  String? attendanceStatus;
  bool enablePermission = false;
  String? permission;

  Future<void> _submitForm(BuildContext context) async {
    // Check if all fields are filled
    if (name.isEmpty || selectedDate == null || attendanceStatus == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter all fields.')),
      );
      return;
    }

    // Extract form field values
    const apiUrl = 'https://btemporary.com/flutter-1/insert.php';

    final formattedDate =
        "${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}";

    final response = await http.post(
      Uri.parse(apiUrl),
      body: {
        'name': name,
        'date_new': formattedDate, // Use formatted date here
        'status': attendanceStatus!,
        'permission': permission ?? '',
      },
    );

    if (response.statusCode == 200) {
      // Handle successful form submission
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ResponsePage()),
      );
    } else {
      // Handle HTTP error
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit form. Please try again later.')),
      );
    }
  }

   @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('User Form'),
        actions: [
          IconButton(
            icon: Icon(Icons.mail),
            onPressed: () {
              // Navigate to EmailPage on mail icon press
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => EmailPage()),
              );
            },
          ),
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              // Navigate to UserLoginPage on logout
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => UserLoginPage()),
              );
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Name :',
              style: TextStyle(fontSize: 16),
            ),
            TextFormField(
              initialValue: name, // Set initial value to the username
              enabled: false, // Disable editing
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Date :',
              style: TextStyle(fontSize: 16),
            ),
            TextFormField(
              readOnly: true,
              onTap: () {
                showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime.now(), // Set firstDate to today
                  lastDate: DateTime.now(), // Set lastDate to today
                ).then((value) {
                  if (value != null) {
                    setState(() {
                      selectedDate = value;
                    });
                  }
                });
              },
              decoration: InputDecoration(
                hintText: selectedDate != null ? selectedDate!.toString().substring(0, 10) : 'Select Date',
                suffixIcon: IconButton(
                  icon: const Icon(Icons.calendar_today),
                  onPressed: () {
                    showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(), // Set firstDate to today
                      lastDate: DateTime.now(), // Set lastDate to today
                    ).then((value) {
                      if (value != null) {
                        setState(() {
                          selectedDate = value;
                        });
                      }
                    });
                  },
                ),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Attendance Status:',
              style: TextStyle(fontSize: 16),
            ),
            RadioListTile<String>(
              title: const Text('Present'),
              value: 'Present',
              groupValue: attendanceStatus,
              onChanged: (value) {
                setState(() {
                  attendanceStatus = value;
                  enablePermission = true;
                  permission = null; // Reset permission when changing attendance status
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Absent'),
              value: 'Absent',
              groupValue: attendanceStatus,
              onChanged: (value) {
                setState(() {
                  attendanceStatus = value;
                  enablePermission = false;
                  permission = null; // Reset permission when changing attendance status
                });
              },
            ),
            RadioListTile<String>(
              title: const Text('Permission'),
              value: 'Permission',
              groupValue: attendanceStatus,
              onChanged: (value) {
                setState(() {
                  if (attendanceStatus == 'Present') {
                    attendanceStatus = value;
                  }
                });
              },
            ),
            if (attendanceStatus == 'Permission')
              TextFormField(
                onChanged: (value) {
                  setState(() {
                    permission = value;
                  });
                },
                decoration: const InputDecoration(
                  labelText: '12.00 PM - 01.00 PM',
                  border: OutlineInputBorder(),
                ),
              ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                _submitForm(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[400],
              ),
              child: const Text('Submit', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }
}
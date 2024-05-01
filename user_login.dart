import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_admin/employee_detail.dart';
import 'package:http/http.dart' as http;

import 'user_form.dart';
import 'selection_page.dart';

class PasswordField extends StatefulWidget {
  final TextEditingController controller;

  const PasswordField({Key? key, required this.controller});

  @override
  _PasswordFieldState createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget.controller,
      decoration: InputDecoration(
        hintText: 'Password',
        border: const OutlineInputBorder(),
        contentPadding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 20.0),
        suffixIcon: GestureDetector(
          onTap: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          child: Icon(
            _obscureText ? Icons.visibility_off : Icons.visibility,
            color: Colors.grey,
          ),
        ),
      ),
      obscureText: _obscureText,
    );
  }
}

class UserLoginPage extends StatelessWidget {
  UserLoginPage({Key? key});

  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  Future<void> _login(BuildContext context)  async {
    final username = usernameController.text;
  final password = passwordController.text;

    // API URL
    final apiUrl =
        'https://btemporary.com/flutter-1/emp_login.php?username=$username&password=$password';

    final response = await http.get(Uri.parse(apiUrl));

    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['Result'] == 'successful') {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => UserForm(username: username)),
        );
      } else {
        const errorMessage = 'Login failed. Please try again.';
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(errorMessage)),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to log in. Please try again later.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                  Image.asset(
                    'assets/images/logo.png', // Replace 'your_image.png' with the path to your image
                    width: 120, // Adjust the width as needed
                    height: 120, // Adjust the height as needed
                  ),
                const SizedBox(height: 50),
                Text(
                  'HELLO EMPLOYEE',
                  style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 25,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: usernameController,
                    decoration: const InputDecoration(
                      hintText: 'Username',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: PasswordField(
                    controller: passwordController,
                  ),
                ),
                const SizedBox(height: 10),
                ElevatedButton(
                  onPressed: () {
                    if (usernameController.text.isNotEmpty &&
                        passwordController.text.isNotEmpty) {
                      _login(context);
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Please enter username and password.'),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  child: const Text(
                    'Log In',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                const SizedBox(height: 10),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const SelectionPage()),
                    );
                  },
                  child: const Text(
                    'Back',
                    style: TextStyle(color: Colors.blue),
                  ),
                ),
                const SizedBox(height: 50),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 10.0),
                      ),
                      Expanded(
                        child: Divider(
                          thickness: 0.5,
                          color: Colors.grey[400],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: false,
                      child: GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EmployeeDetail(),
                            ),
                          );
                        },
                        child: const Text(
                          'Register now',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: UserLoginPage(),
  ));
}
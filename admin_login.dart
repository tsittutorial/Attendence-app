// ignore_for_file: use_build_context_synchronously, duplicate_ignore

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_admin/selection_page.dart';
import 'package:http/http.dart' as http;

import 'employee_detail.dart';
import 'hello_admin.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();

  bool _obscureText = true;

  Future<void> _login(BuildContext context) async {
    final username = usernameController.text;
    final password = passwordController.text;

    // API URL
    final apiUrl =
        'https://btemporary.com/flutter-1/login.php?username=$username&password=$password';

    final response = await http.get(Uri.parse(apiUrl));



    if (response.statusCode == 200) {
      final responseData = json.decode(response.body);

      if (responseData['Result'] == 'successful') {
        // Redirect to admin dashboard page
        Navigator.push(
          // ignore: use_build_context_synchronously
          context,
          MaterialPageRoute(builder: (context) => const HelloAdminPage()),
        );
        
      } else {
        // Handle unsuccessful login
        const errorMessage = 'Login failed. Please try again.';
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text(errorMessage)),
        );
      }
    } else {
      // Handle HTTP error
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
                  'HELLO ADMIN',
                  style: TextStyle(
                      color: Colors.blue[700],
                      fontSize: 25,
                      fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 25),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
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
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      hintText: 'Password',
                      border: const OutlineInputBorder(),
                      suffixIcon: IconButton(
                        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText; // Update obscure text state
                          });
                        },
                      ),
                    ),
                    obscureText: _obscureText,
                  ),
                ),
                const SizedBox(height: 10),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                //   child: Row(
                //     mainAxisAlignment: MainAxisAlignment.end,
                //     children: [
                //       Text(
                //         'Forgot Password?',
                //         style: TextStyle(color: Colors.grey[600]),
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 25),
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
                  child: const Text('Log In',
        style: TextStyle(color: Colors.white),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.blue,
        shadowColor: Colors.white,
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
                // const SizedBox(height: 50),
                // Padding(
                //   padding: const EdgeInsets.symmetric(horizontal: 25.0),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: Divider(
                //           thickness: 0.5,
                //           color: Colors.grey[400],
                //         ),
                //       ),
                //       Padding(
                //         padding: const EdgeInsets.symmetric(horizontal: 10.0),
                //         child: Text(
                //           '',
                //           style: TextStyle(color: Colors.grey[700]),
                //         ),
                //       ),
                //       Expanded(
                //         child: Divider(
                //           thickness: 0.5,
                //           color: Colors.grey[400],
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () {
                        // Redirect to employee detail page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const EmployeeDetail()),
                        );
                      },
                      child: const Text(
                        '',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
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
  runApp(const MaterialApp(
    title: 'Login App',
    home: LoginPage(),
  ));
}
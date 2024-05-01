import 'package:flutter/material.dart';

import 'user_login.dart';

class ResponsePage extends StatelessWidget {
  const ResponsePage({Key? key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Form Submitted'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.check_circle_outline,
              size: 100,
              color: Colors.green,
            ),
            const SizedBox(height: 20),
            const Text(
              'Your response is submitted!',
              style: TextStyle(fontSize: 24),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Perform logout action here
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (context) => UserLoginPage()),
                  );              
            },//onpressed 
            style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
              child: const Text(
                  'Logout',
                  style: TextStyle(color: Colors.white),
              ),            
            ),
          ],
        ),
      ),
    );
  }
}

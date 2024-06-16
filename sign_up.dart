import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class RegisterForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Color(0xFF212121),
        appBar: AppBar(
          title: Text('Game Registration'),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('assets/2.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: 1,
              child: Container(
                margin: EdgeInsets.all(16.0),
                padding: EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: RegisterFormFields(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class RegisterFormFields extends StatefulWidget {
  @override
  _RegisterFormFieldsState createState() => _RegisterFormFieldsState();
}

class _RegisterFormFieldsState extends State<RegisterFormFields> {
  final TextEditingController _registrationNumberController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _createPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController = TextEditingController();

  Future<void> _register() async {
    String registrationNumber = _registrationNumberController.text;
    String lastName = _lastNameController.text;
    String createPassword = _createPasswordController.text;
    String confirmPassword = _confirmPasswordController.text;

    try {
      var response = await http.post(
        Uri.parse('http://localhost/api/register.php'),
        body: {
          'registrationNumber': registrationNumber,
          'lastName': lastName,
          'createPassword': createPassword,
          'confirmPassword': confirmPassword,
        },
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 200) {
        var jsonResponse = jsonDecode(response.body);
        print('JSON Response: $jsonResponse');

        if (jsonResponse['success'] == true) {
          _showDialog('Registration Successful', 'Your registration was successful.');
        } else {
          _showDialog('Registration Failed', jsonResponse['message'] ?? 'Unknown error');
        }
      } else {
        _showDialog('Error', 'Failed to register. Please try again.');
      }
    } catch (e) {
      _showDialog('Registration Successful', 'Your registration was successful.');
      print(e);
    }
  }

  void _showDialog(String title, String content) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(content),
          actions: [
            TextButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0),
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 500),
            opacity: 1,
            child: Text(
              'Player Registration',
              style: TextStyle(
                color: Colors.black,
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: 1,
          child: Column(
            children: [
              SizedBox(height: 20.0),
              TextFormField(
                controller: _registrationNumberController,
                decoration: InputDecoration(
                  labelText: 'Registration Number',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: _lastNameController,
                decoration: InputDecoration(
                  labelText: 'Last Name',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: _createPasswordController,
                decoration: InputDecoration(
                  labelText: 'Create Password',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 12.0),
              TextFormField(
                controller: _confirmPasswordController,
                decoration: InputDecoration(
                  labelText: 'Confirm Password',
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    borderSide: BorderSide(color: Colors.black),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 20.0),
              ElevatedButton(
                onPressed: _register,
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 12.0),
                  child: Text(
                    'Register',
                    style: TextStyle(
                      fontSize: 20.0,  // Adjusted font size
                      fontWeight: FontWeight.bold,  // Bold text
                    ),
                  ),
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, backgroundColor: Colors.green,
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _registrationNumberController.dispose();
    _lastNameController.dispose();
    _createPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }
}

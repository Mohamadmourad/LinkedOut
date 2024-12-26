import 'dart:convert';

import 'package:client/components/CustomButton.dart';
import 'package:client/components/input.dart';
import 'package:client/pages/Home.dart';
import 'package:client/pages/Login.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String emailError = "";
  String passwordError = "";
  String selectedValue = "jobSeeker";

   Future<void> handleSignup() async {
    setState(() => isLoading = true);
    final email = emailController.text.trim();
    final password = passwordController.text.trim();

    if (email.isEmpty) {
      setState(() => emailError = "Email is required.");
    } 
    else {
      setState(() => emailError = "");
    }

    if (password.isEmpty) {
      setState(() => passwordError = "Password is required.");
    } else if (password.length < 6) {
      setState(() => passwordError = "Password must be at least 6 characters.");
    } else {
      setState(() => passwordError = "");
    }

    if (emailError.isNotEmpty || passwordError.isNotEmpty) return;

    final url = Uri.parse("http://192.168.1.8/linkedout/signup.php");
    final body = {
      "email": email,
      "password": password,
      "role": selectedValue,
    };

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(body),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['status'] == 200) {
          var userId = data['user_id'];
          print(userId);
          print("Signup successful!");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => Home( userId: userId, role: selectedValue)),
          );
        }
        else if(data['status'] == 403) {
          print("Signup failed: ${data['message']}");
          setState(() => emailError = "email already exists");
        }
         else {
          print("Signup failed: ${data['message']}");
        }
      } 
    } catch (e) {
      print("Error: $e");
    }
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          shrinkWrap: true,
          children: [
            const SizedBox(height: 100),
            Text(
              "SignUp",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.purpleAccent,
              ),
            ),
            Input(
              label: "Email",
              error: emailError,
              controller: emailController,
              isPassword: false,
            ),
            Input(
              label: "Password",
              error: passwordError,
              controller: passwordController,
              isPassword: true,
            ),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.all(20),
              child: DropdownButton<String>(
                value: selectedValue,
                dropdownColor: Colors.grey[800],
                style: TextStyle(color: Colors.purpleAccent),
                items: [
                  DropdownMenuItem(
                    value: "jobSeeker",
                    child: Text("job seeker"),
                  ),
                  DropdownMenuItem(
                    value: "recruiter",
                    child: Text("recruiter"),
                  ),
                ],
                onChanged: (value) {
                  setState(() {
                    selectedValue = value!;
                  });
                },
              ),
            ),
            const SizedBox(height: 60),
            CustomButton(
              label: isLoading ? "Loading..." : "Create Account",
              onPressed: handleSignup,
              color: Colors.purpleAccent,
            ),
            CustomButton(
              label: "You already have an account? Login",
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Login()),
                );
              },
              color: Colors.purple,
            ),
          ],
        ),
      ),
    );
  }
}

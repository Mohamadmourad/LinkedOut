import 'package:client/components/CustomButton.dart';
import 'package:client/components/Input.dart';
import 'package:client/pages/Home.dart';
import 'package:client/pages/Signup.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool isLoading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String emailError = "";
  String passwordError = "";

  Future<void> handleLogin() async {
    setState(() {
      isLoading = true;
    });
    if (emailController.text.isEmpty) {
      setState(() {
        emailError = "Email is required";
      });
    } else {
      setState(() {
        emailError = "";
      });
    }

    if (passwordController.text.isEmpty) {
      setState(() {
        passwordError = "Password is required";
      });
    } else {
      setState(() {
        passwordError = "";
      });
    }

    if (emailController.text.isNotEmpty && passwordController.text.isNotEmpty) {
      final url = Uri.parse("http://192.168.1.8/linkedout/login.php");
      try {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode({
            "email": emailController.text,
            "password": passwordController.text,
          }),
        );
        final data = jsonDecode(response.body);
        if (data["status"] == 200) {
          var user = data["user"];
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => Home(
                userId: user["id"],
                role: user["role"],
              ),
            ),
          );
        } else {
          setState(() {
            emailError = data["message"];
          });
        }
      } catch (e) {
        print(e);
      }
      setState(() {
        isLoading = false;
      });
    }
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
              "Login",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 35,
                fontWeight: FontWeight.bold,
                color: Colors.blueGrey,
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
            const SizedBox(height: 60),
            CustomButton(
              label: isLoading ? "Loading..." : "Login",
              onPressed: handleLogin,
              color: Colors.blueGrey,
            ),
            CustomButton(
              label: "Don't have an account? Signup",
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => Signup()),
                );
              },
              color: Colors.blueGrey,
            ),
          ],
        ),
      ),
    );
  }
}

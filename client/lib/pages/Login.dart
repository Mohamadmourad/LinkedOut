import 'package:client/components/CustomButton.dart';
import 'package:client/components/input.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  String emailError = "";
  String passwordError = "";

  Future<void> handleLogin() async {
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
      print("Email: ${emailController.text}");
      print("Password: ${passwordController.text}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 100),
                Text(
                "Login",
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
              const SizedBox(height: 60),
              CustomButton(
                label: "Login",
                onPressed: handleLogin,
                color: Colors.purpleAccent, 
             ),

             CustomButton(
                label: "Dont have and account? Signup",
                onPressed: (){
                  
                },
                color: Colors.purple, 
             ),
          ],
        ),
      ),
    );
  }
}
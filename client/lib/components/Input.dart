import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  final String label;
  final String error;
  final TextEditingController? controller;
  final bool isPassword;
  const Input(
      {super.key,
      required this.label,
      required this.error,
      this.controller,
      required this.isPassword});

  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              cursorColor: Colors.blueGrey,
              controller: widget.controller,
              obscureText: widget.isPassword,
              style: const TextStyle(color: Colors.white),
              decoration: InputDecoration(
                label: Text(
                  widget.label,
                  style: TextStyle(color: Colors.blueGrey),
                ),
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey, width: 3.0),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(color: Colors.blueGrey, width: 2.0),
                ),
              ),
            ),
            const SizedBox(height: 5),
            Text(
              widget.error,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            )
          ],
        ));
  }
}

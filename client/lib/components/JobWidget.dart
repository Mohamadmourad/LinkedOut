import 'package:flutter/material.dart';

class JobWidget extends StatelessWidget {
  final String name;
  final String description;
  final String skills;
  final VoidCallback onViewApplicants;

  const JobWidget({
    Key? key,
    required this.name,
    required this.description,
    required this.skills,
    required this.onViewApplicants,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      color: Colors.blueGrey[100],
      child: Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              name,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(description),
            const SizedBox(height: 10),
            Text("Skills: $skills"),
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: TextButton(
                onPressed: onViewApplicants,
                child: const Text(
                  "View Applicants",
                  style: TextStyle(color: Colors.blueGrey),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

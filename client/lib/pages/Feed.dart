import 'package:flutter/material.dart';
import 'Profile.dart';

class Feed extends StatelessWidget {
  final List<Map<String, String>> jobs = [
    {
      "name": "Software Engineer",
      "description": "Develop and maintain software solutions.",
      "skills": "Flutter, Dart, Firebase"
    },
    {
      "name": "Data Analyst",
      "description": "Analyze and interpret complex datasets.",
      "skills": "Python, SQL, Excel"
    },
    {
      "name": "UX Designer",
      "description": "Design user interfaces and improve user experience.",
      "skills": "Figma, Adobe XD, User Research"
    },
  ];

  void applyForJob(BuildContext context, String jobName) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('You have applied for $jobName!'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: const Text('Job Feed'),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ProfilePage()),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: jobs.length,
        itemBuilder: (context, index) {
          final job = jobs[index];
          return Card(
            margin: const EdgeInsets.all(10),
            color: Colors.grey[900],
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    job["name"]!,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    job["description"]!,
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    "Skills: ${job["skills"]}",
                    style: const TextStyle(color: Colors.grey),
                  ),
                  const SizedBox(height: 10),
                  ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all(Colors.blueGrey),
                    ),
                    onPressed: () => applyForJob(context, job["name"]!),
                    child: const Text(
                      'Apply',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}

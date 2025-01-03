import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final int userId;
   const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String profileName = "John Doe";
  String profileBio =
      "Passionate developer with a love for building user-friendly applications.";
  List<String> skills = [
    "Flutter",
    "Dart",
    "Firebase",
    "JavaScript",
    "React",
    "Python",
    "Node.js",
    "SQL",
    "Git",
    "REST APIs",
  ];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController skillController = TextEditingController();

  @override
  void initState() {
    super.initState();
    nameController.text = profileName;
    bioController.text = profileBio;
  }

  Future<void> saveProfile() async {
    final url = 'http://linkedout.42web.io/addProfile.php';
    final newSkill = skillController.text.trim();
    final body = {
      'userId': widget.userId, // Replace with actual user ID
      'name': profileName,
      'bio': profileBio,
      'skill': newSkill.isNotEmpty ? newSkill : '',
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
      // Handle success
      if (newSkill.isNotEmpty) {
        setState(() {
          skills.add(newSkill);
          skillController.clear();
        });
      }
    } else {
      // Handle error
    }
  }

  void removeSkill(String skill) {
    setState(() {
      skills.remove(skill);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              CircleAvatar(
                radius: 50,
                backgroundColor: Colors.blueGrey,
                child: const Icon(
                  Icons.person,
                  size: 50,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 20),
              TextFormField(
                cursorColor: Colors.blueGrey,
                controller: nameController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Name",
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    profileName = value;
                  });
                  saveProfile();
                },
              ),
              const SizedBox(height: 10),
              TextFormField(
                cursorColor: Colors.blueGrey,
                controller: bioController,
                style: const TextStyle(color: Colors.white),
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: "Bio",
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    profileBio = value;
                  });
                  saveProfile();
                },
              ),
              const SizedBox(height: 20),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  "Skills",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blueGrey[200],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Wrap(
                spacing: 10,
                runSpacing: 10,
                children: skills.map((skill) {
                  return Chip(
                    label: Text(
                      skill,
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.blueGrey,
                    deleteIcon: const Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                    onDeleted: () {
                      removeSkill(skill);
                    },
                  );
                }).toList(),
              ),
              const SizedBox(height: 20),
              TextFormField(
                cursorColor: Colors.blueGrey,
                controller: skillController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Add Skill",
                  labelStyle: TextStyle(color: Colors.blueGrey),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blueGrey),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.blue),
                  ),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.blueGrey),
                ),
                onPressed: saveProfile,
                child: const Text(
                  "Save",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

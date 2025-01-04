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
  String profileName = "";
  String profileBio = "";
  List<String> skills = [];

  final TextEditingController nameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController skillController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchProfile();
    nameController.text = profileName;
    bioController.text = profileBio;
  }

  Future<void> fetchProfile() async {
    final url =
        'https://phhhhp.youssofkhawaja.com/getProfile.php?userId=${widget.userId}';
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      if (data['status'] == 200) {
        final user = data['user'];
        print(user['skills']);
        setState(() {
          profileName = user['username'] ?? 'John Doe';
          profileBio = user['bio'] ??
              'Passionate developer with a love for building user-friendly applications.';
          skills = List<String>.from(user['skills'] ?? []);
        });
        nameController.text = profileName;
        bioController.text = profileBio;
      }
    }
  }

  Future<void> saveProfile() async {
    final url = 'https://phhhhp.youssofkhawaja.com/addProfile.php';
    final body = {
      'userId': widget.userId,
      'name': profileName,
      'bio': profileBio,
      'skill': skills,
    };

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {
    } else {}
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
                onPressed: () {
                  final inputText = skillController.text.trim();
                  if (inputText.isNotEmpty) {
                    final newSkills = inputText
                        .split(',')
                        .map((s) => s.trim())
                        .where((s) => s.isNotEmpty)
                        .toList();
                    setState(() {
                      skills.addAll(newSkills);
                      skillController.clear();
                    });
                  }
                  saveProfile();
                },
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

import 'package:client/components/CustomButton.dart';
import 'package:flutter/material.dart';
import 'package:client/components/Input.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AddJob extends StatefulWidget {
  final ownerId;
  const AddJob({super.key, required this.ownerId});

  @override
  State<AddJob> createState() => _AddJobState();
}

class _AddJobState extends State<AddJob> {
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  TextEditingController skillController = TextEditingController();

  String nameError = "";
  String descriptionError = "";
  List<String> skills = [];
  final List<String> availableSkills = [
    "Java",
    "Javascript",
    "Nodejs",
    "Python",
    "R",
    "React",
    "Flutter"
  ];

  Future<void> handleSubmit() async {
    if (nameController.text.isEmpty) {
      setState(() {
        nameError = "Name is required.";
      });
    } else if (descriptionController.text.isEmpty) {
      setState(() {
        descriptionError = "Description is required.";
      });
    } else {
      String fullSkillsList = "";
      for (String skill in skills) {
        fullSkillsList += skill + ", ";
      }

      final url = Uri.parse("http://192.168.1.8/linkedOut/addJob.php");
      final body = {
        "name": nameController.text.trim(),
        "description": descriptionController.text.trim(),
        "skills": fullSkillsList,
        "owner": widget.ownerId,
      };

      try {
        final response = await http.post(
          url,
          headers: {"Content-Type": "application/json"},
          body: jsonEncode(body),
        );
        if (response.statusCode == 200) {
          Navigator.pop(context, true);
        }
      } catch (e) {
        print("Error: $e");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: const Text('Add Job'),
        backgroundColor: Colors.blueGrey,
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Input(
                    label: "Name",
                    error: nameError,
                    controller: nameController,
                    isPassword: false,
                  ),
                  const SizedBox(height: 20),
                  Input(
                    label: "Description",
                    error: descriptionError,
                    controller: descriptionController,
                    isPassword: false,
                  ),
                  const SizedBox(height: 20),
                  Container(
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.blueGrey, width: 2.0),
                      borderRadius: BorderRadius.circular(5.0),
                      color: Colors.blueGrey[100],
                    ),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                    child: DropdownButton<String>(
                      hint: const Text(
                        "Select a skill",
                        style: TextStyle(color: Colors.blueGrey),
                      ),
                      value: null,
                      isExpanded: true,
                      icon: const Icon(Icons.arrow_drop_down,
                          color: Colors.blueGrey),
                      underline: Container(),
                      dropdownColor: Colors.blueGrey[200],
                      style:
                          const TextStyle(color: Colors.blueGrey, fontSize: 16),
                      items: availableSkills
                          .map((skill) => DropdownMenuItem<String>(
                                value: skill,
                                child: Text(skill),
                              ))
                          .toList(),
                      onChanged: (value) {
                        if (value != null && !skills.contains(value)) {
                          setState(() {
                            skills.add(value);
                          });
                        }
                      },
                    ),
                  ),
                  const SizedBox(height: 10),
                  Wrap(
                    spacing: 10,
                    runSpacing: 10,
                    children: skills
                        .map((skill) => Chip(
                              label: Text(skill),
                              deleteIcon:
                                  const Icon(Icons.close, color: Colors.white),
                              onDeleted: () {
                                setState(() {
                                  skills.remove(skill);
                                });
                              },
                              backgroundColor: Colors.blueGrey,
                              labelStyle: const TextStyle(color: Colors.white),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20),
            child: CustomButton(
              label: "Submit",
              onPressed: handleSubmit,
              color: Colors.blueGrey,
            ),
          ),
        ],
      ),
    );
  }
}

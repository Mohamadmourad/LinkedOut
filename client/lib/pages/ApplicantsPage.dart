import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ApplicantsPage extends StatefulWidget {
  final String jobId;

  const ApplicantsPage({Key? key, required this.jobId}) : super(key: key);

  @override
  State<ApplicantsPage> createState() => _ApplicantsPageState();
}

class _ApplicantsPageState extends State<ApplicantsPage> {
  List<Map<String, dynamic>> applicants = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchApplicants();
  }

  Future<void> fetchApplicants() async {
    final url = Uri.parse(
        "https://phhhhp.youssofkhawaja.com/getApplicantsByJobId.php?jobId=${widget.jobId}");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        print(data);
        setState(() {
          applicants = data.cast<Map<String, dynamic>>();
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error fetching applicants: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: const Text("Applicants"),
        backgroundColor: Colors.blueGrey,
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : applicants.isEmpty
              ? const Center(
                  child: Text(
                    'No applicants found.',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  itemCount: applicants.length,
                  itemBuilder: (context, index) {
                    final applicant = applicants[index];
                    return ListTile(
                      title: Text(
                        "Username: " + applicant['username'],
                        style: const TextStyle(color: Colors.white),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Email: " + applicant['email'],
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Text(
                            "Bio: " + applicant['bio'],
                            style: const TextStyle(color: Colors.grey),
                          ),
                          Text(
                            'Applied on: ${applicant['dateOfApplication']}',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                      trailing:
                          const Icon(Icons.person, color: Colors.blueGrey),
                    );
                  },
                ),
    );
  }
}

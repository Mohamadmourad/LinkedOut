import 'package:flutter/material.dart';
import 'Profile.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class Feed extends StatefulWidget {
  final int userId;

  Feed({required this.userId});

  @override
  _FeedState createState() => _FeedState();
}

class _FeedState extends State<Feed> {
  List<Map<String, String>>? jobs; 
  bool _isLoading = true; 
  Set<String> _appliedJobs = {}; 

  Future<List<Map<String, String>>> fetchJobs(int userId) async {
    final response = await http
        .get(Uri.parse('https://phhhhp.youssofkhawaja.com/getJobs.php'));
    if (response.statusCode == 200) {
      final decoded = json.decode(response.body);
      final data = decoded["data"] as List<dynamic>;
      return data
          .map((item) => {
                "jobId": item["jobId"]?.toString() ?? "",
                "name": item["name"]?.toString() ?? "",
                "description": item["description"]?.toString() ?? "",
                "skills": item["skills"]?.toString() ?? ""
              })
          .toList();
    } else {
      throw Exception('Failed to load jobs');
    }
  }

  Future<Map<String, dynamic>> applyJob(int userId, String jobId) async {
    final response = await http.post(
      Uri.parse('https://phhhhp.youssofkhawaja.com/applyJob.php'),
      body: {
        'userId': userId.toString(),
        'jobId': jobId,
      },
    );

    return json.decode(response.body);
  }

  @override
  void initState() {
    super.initState();
    fetchJobs(widget.userId);
  }

  void applyForJob(BuildContext context, String jobName) {
    setState(() {
      _appliedJobs.add(jobName); 
    });
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
                MaterialPageRoute(builder: (context) => ProfilePage(userId: widget.userId)),
              );
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : jobs == null || jobs!.isEmpty
              ? const Center(
                  child: Text(
                    'No jobs available.',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  itemCount: jobs!.length,
                  itemBuilder: (context, index) {
                    final job = jobs![index];
                    final isApplied = _appliedJobs.contains(job["name"]);
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
                                backgroundColor: MaterialStateProperty.all(
                                  isApplied ? Colors.grey : Colors.blueGrey,
                                ),
                              ),
                              onPressed: isApplied
                                  ? null 
                                  : () => applyForJob(context, job["name"]!),
                              child: Text(
                                isApplied ? 'Applied' : 'Apply',
                                style: const TextStyle(color: Colors.white),
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

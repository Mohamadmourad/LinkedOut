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

  Future<void> fetchJobs(int userId) async {
    try {
      final response = await http.get(Uri.parse('http://linkedout.42web.io/getJobs'));
      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        setState(() {
          jobs = data
              .map((item) => {
                    "name": item["name"]?.toString() ?? "",
                    "description": item["description"]?.toString() ?? "",
                    "skills": item["skills"]?.toString() ?? ""
                  })
              .toList();
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load jobs');
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print(e);
    }
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
                                  ? null // Disable the button if already applied
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

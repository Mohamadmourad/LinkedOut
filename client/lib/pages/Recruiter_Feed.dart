import 'dart:convert';
import 'package:client/components/JobWidget.dart';
import 'package:client/pages/AddJob.dart';
import 'package:client/pages/ApplicantsPage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Recuiter_Feed extends StatefulWidget {
  final String ownerId;
  const Recuiter_Feed({super.key, required this.ownerId});

  @override
  State<Recuiter_Feed> createState() => _Recuiter_FeedState();
}

class _Recuiter_FeedState extends State<Recuiter_Feed> {
  List<Map<String, dynamic>> jobs = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchJobs();
  }

  Future<void> fetchJobs() async {
    final url = Uri.parse("http://192.168.1.8/linkedout/getJobById.php?id=${widget.ownerId}");
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body)['data'];
        setState(() {
          jobs = data.cast<Map<String, dynamic>>();
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
      print("Error fetching jobs: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      appBar: AppBar(
        title: const Text('Your Listings'),
        backgroundColor: Colors.blueGrey,
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => AddJob(ownerId: widget.ownerId)),
              );
            },
          ),
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : jobs.isEmpty
              ? const Center(
                  child: Text(
                    'No jobs found.',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              : ListView.builder(
                  itemCount: jobs.length,
                  itemBuilder: (context, index) {
                    final job = jobs[index];
                    return JobWidget(
                      name: job['name'],
                      description: job['description'],
                      skills: job['skills'],
                      onViewApplicants: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ApplicantsPage(jobId: job['jobId']),
                          ),
                        );
                      },
                    );
                  },
                ),
    );
  }
}

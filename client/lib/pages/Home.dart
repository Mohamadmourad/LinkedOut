import 'package:client/pages/Feed.dart';
import 'package:client/pages/Recruiter_Feed.dart';
import 'package:flutter/material.dart';

class Home extends StatelessWidget {
  final userId;
  final role;
  const Home({super.key, required this.userId, required this.role});

  @override
  Widget build(BuildContext context) {
    if (role == "jobSeeker") {
      return Feed(
        userId: userId,
      );
    } else {
      return Recuiter_Feed(ownerId: userId);
    }
  }
}

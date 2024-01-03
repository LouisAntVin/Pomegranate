import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pomegranate/allposts.dart';
import 'package:pomegranate/branch.dart';

class Profile extends StatefulWidget {
  final String SelectedBranch;
  final String SelectedSemester;
  const Profile(this.SelectedBranch, this.SelectedSemester);
  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  final currentUser = FirebaseAuth.instance.currentUser!;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF30303B),
      appBar: AppBar(
        title: const Text('Profile'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(currentUser.displayName!,
                style: TextStyle(
                    fontSize: 35,
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w700)),
            Text(currentUser.email!,
                style: TextStyle(fontSize: 20, color: Colors.redAccent)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(color: Colors.white60),
            ),
            Text('Branch: ${widget.SelectedBranch}',
                style: TextStyle(fontSize: 19, color: Colors.redAccent)),
            Text('Semester: ${widget.SelectedSemester}',
                style: TextStyle(fontSize: 19, color: Colors.redAccent)),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Divider(color: Colors.white60),
            ),
            SizedBox(
              height: 20,
            ),
            const Align(
                alignment: Alignment.centerLeft,
                child: Text('More Options:',
                    style: TextStyle(
                        fontSize: 14,
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w700))),
            SizedBox(
              height: 10,
            ),
            InkWell(
              splashColor: Colors.white60,
              child: Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(8),
                child: const Text(
                  "Change Branch and Semester",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.redAccent,
                  ),
                ),
              ),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Branch(),//To change branch and sem
                  ),
                );
              },
            ),
            Divider(color: Colors.white12),
            InkWell(
              splashColor: Colors.white60,
              child: Container(
                alignment: Alignment.topLeft,
                padding: const EdgeInsets.all(8),
                child: const Text(
                  "Uploaded Posts",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w400,
                    color: Colors.redAccent,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MyPost(),
                  ),
                );
              },//To open user's uploaded posts
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:pomegranate/Util/authentication.dart';
import 'package:pomegranate/login.dart';
import 'package:pomegranate/profile.dart';
import 'package:pomegranate/subject.dart';

class HomePage extends StatefulWidget {
  final String SelectedBranch;
  final String SelectedSemester;
  const HomePage(this.SelectedBranch, this.SelectedSemester);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF30303B),
      appBar: AppBar(
        title: const Text('Home'),
        leading: IconButton(
          onPressed: () {
            Navigator.push(
                      context,
                      MaterialPageRoute(builder: (contex) => Profile(widget.SelectedBranch, widget.SelectedSemester)),
            );
          },
          icon: Icon(Icons.person),
          tooltip: 'Logout',
        ),
        actions: [
          IconButton(
            onPressed: () {
              AuthenticationHelper()
                  .signOut()
                  .then((_) => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (contex) => Login()),
                      ));
            },
            icon: Icon(Icons.logout),
            tooltip: 'Logout',
          )
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Image.asset(
                  'assets/images/pome logo.png',
                  height: 70,
                ),
                Column(
                  children: [
                    const Text(
                      "Welcome",
                      style: TextStyle(
                          color: Colors.redAccent,
                          fontSize: 30,
                          fontWeight: FontWeight.bold),
                      textAlign: TextAlign.left,
                    ),
                    Text(
                      FirebaseAuth.instance.currentUser!.displayName!,
                      style: TextStyle(color: Colors.redAccent, fontSize: 25),
                      textAlign: TextAlign.left,
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(
            color: Colors.white38,
            indent: 15,
            endIndent: 15,
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Material(
                elevation: 9,
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  height: 100,
                  child: InkWell(
                    splashColor: Colors.red,
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      child: const Center(
                        child: Text(
                          "SELECT SUBJECT",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 30, // Set the font size
                            fontWeight: FontWeight.bold, // Make the text bold
                            color: Colors.black, // Set the text color
                          ),
                        ),
                      ),
                    ),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Subject(
                              widget.SelectedBranch, widget.SelectedSemester),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          const Padding(
            padding: const EdgeInsets.all(8.0),
            child:  Text(
              "Saved Posts",
              style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
          ),
          const Divider(
            color: Colors.white12,
            indent: 15,
            endIndent: 15,
          ),
        ],
      ),
    );
  }
}

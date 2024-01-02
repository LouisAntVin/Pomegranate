import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:pomegranate/module.dart';
import 'package:pomegranate/post.dart';

class Subject extends StatefulWidget {
  final String SelectedBranch;
  final String SelectedSemester;
  const Subject(this.SelectedBranch, this.SelectedSemester);

  @override
  State<Subject> createState() => _SubjectState();
}

class _SubjectState extends State<Subject> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<dynamic> subjectList = [];
  var _subject;

  getdata() async {
    await db
        .collection(widget.SelectedBranch)
        .doc(widget.SelectedSemester)
        .get()
        .then(
      (value) {
        subjectList = value.data()?["SUBJECTS"];
        print(subjectList);
        setState(() {});
      },
    );
  }

  @override
  void initState() {
    super.initState();
    getdata();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xFF30303B), //
        appBar: AppBar(
          title: Text('Choose Your Subject'),
        ),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: subjectList.length,
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      setState(() {
                        _subject = subjectList[index];
                      });
                      if (_subject.toString().trim().endsWith("LAB")) {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Post(widget.SelectedBranch,
                                widget.SelectedSemester, _subject, "1"),
                          ),
                        );
                      }
                      else {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Module(widget.SelectedBranch,
                                widget.SelectedSemester, _subject),
                          ),
                        );
                      }
                    },
                    child: Card(
                      child: ListTile(
                        title: Text(subjectList[index].toString()),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ));
  }
}

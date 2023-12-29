import 'package:flutter/material.dart';
import 'package:pomegranate/home.dart';

class Semester extends StatefulWidget {
  final String SelectedBranch;

  const Semester(this.SelectedBranch);

  @override
  State<Semester> createState() => _SemesterState();
}

class _SemesterState extends State<Semester> {
  @override
  var _semester;
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: Color(0xFF30303B),
        appBar: AppBar(
          title: Text('Choose Your Semester'),
        ),
        body: Container(
          child: SingleChildScrollView(
            child: Column(
              children: [
                CustomScrollView(
                  primary: false,
                  shrinkWrap: true,
                  slivers: <Widget>[
                    SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverGrid.count(
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        crossAxisCount: 2, // Updated to have 2 columns
                        children: <Widget>[
                          buildGridItem('1'),
                          buildGridItem('2'),
                          buildGridItem('3'),
                          buildGridItem('4'),
                          buildGridItem('5'),
                          buildGridItem('6'),
                          buildGridItem('7'),
                          buildGridItem('8'),
                        ],
                      ),
                    ),
                  ],
                ),
                // Add more widgets below if needed
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget buildGridItem(String text) {
    return Material(
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
          splashColor: Colors.red,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.all(8),
            child: Center(
              child: Text(
                text,
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
            setState(() {
              _semester = text; //here
            });
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(widget.SelectedBranch,_semester),
              ),
            );
          }),
    );
  }
}

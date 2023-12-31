import 'package:flutter/material.dart';
import 'package:pomegranate/semester.dart';

class Branch extends StatefulWidget {
  const Branch({Key? key}) : super(key: key);

  @override
  State<Branch> createState() => _BranchState();
}

class _BranchState extends State<Branch> {
  @override
  late String _branch;

  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Color(0xFF30303B),
        appBar: AppBar(
          title: Text('Choose Your Branch'),
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
                        crossAxisCount: MediaQuery.of(context).size.width.floor() >500 ? 4 :2, // Updated to have 2 columns
                        children: <Widget>[
                          buildGridItem('CSE'),
                          buildGridItem('CSBS'),
                          buildGridItem('AIDS'),
                          buildGridItem('CE'),
                          buildGridItem('ME'),
                          buildGridItem('AEI'),
                          buildGridItem('ECE'),
                          buildGridItem('EEE'),
                          buildGridItem('IT'),
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
                style: const TextStyle(
                  fontSize: 30, // Set the font size
                  fontWeight: FontWeight.bold, // Make the text bold
                  color: Colors.black, // Set the text color
                ),
              ),
            ),
          ),
          onTap: () {
            setState(() {
              _branch=text;
            });

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => Semester(_branch),
              ),
            );
          }),
    );
  }
}

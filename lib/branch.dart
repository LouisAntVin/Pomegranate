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
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Choose Your Branch'),
        ),
        body: Container(
          color: Colors.grey[600], // Set the overall background color to grey
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
                          buildGridItem('CSE'),
                          buildGridItem('csbs'),
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
              _branch=text;
            });

            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Semester(_branch),
              ),
            );
          }),
    );
  }
}
